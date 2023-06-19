module Scraping
  module Sources
    class Base
      include ScrapingHelper

      private

      def extract_job_previews_from_page(all_jobs_page, searched_location = nil)
        job_elements(all_jobs_page).each_with_object([]) do |job_element, jobs|
          job_preview = create_job_preview(job_element, searched_location)
          jobs << job_preview
        rescue => e
          SendToErrorMonitors.send_error(error: e, additional: { job: job_element })
        end
      end

      def decide_job_previews_to_scrape(job_previews)
        filtered_jobs = JobPreviewEvaluation::Pipeline.new(job_previews).process
        filtered_jobs.select{ |job_preview| job_preview.status == "evaluated" }
      end

      def scrape_jobs(job_previews)
        job_previews.each do |job_preview|
          options = scrape_job_page_options(job_preview)
          job_page = ScrapePage.call(**options)

          create_job(job_preview, job_page)
        rescue => e
          rollbar_error = SendToErrorMonitors.send_error(error: e, additional: { job: job_preview.instance_values.to_s })

          if job_page
            job_for_email = job_preview.attributes
            job_for_email["description"] = "removed"

            ScraperMailer.job_save_error_html(
              html: job_page.to_html,
              job: job_for_email,
              error: e,
              rollbar_uuid: rollbar_error[:uuid]
            ).deliver_now
          end
        end
      end

      def save_job(job, scraped_page = nil)
        job.save!
      rescue => e
        rollbar_error = SendToErrorMonitors.send_error(error: e, additional: { job: job.attributes })

        if scraped_page
          job_for_email = job.attributes
          job_for_email["description"] = "removed"

          ScraperMailer.job_save_error_html(
            html: scraped_page.to_html,
            job: job_for_email,
            error: e,
            rollbar_uuid: rollbar_error[:uuid]
          ).deliver_now
        end
      end

      def field_empty?(field)
        field == "" || field == " " || field == nil
      end

      ###### DEFAULTS ######
      def job_element_company(_job)
        nil
      end

      def job_element_location(_job)
        nil
      end

      def scrape_all_jobs_page_options(link)
        {
          link: link
        }
      end

      def scrape_job_page_options(job)
        {
          link: job.url
        }
      end
      ######################
    end
  end
end
