module Scraping
  class LinkedinScraper < DefaultScraper
    private

    def source
      :linkedin
    end

    def scrape_all_jobs_page_options(link)
      {
        link: link,
        wait_time: 5000,
        premium_proxy: true
      }
    end

    def scrape_job_page_options(job)
      {
        link: job.job_link,
        wait_time: 6000,
        premium_proxy: true,
        javascript_snippet: javascript
      }
    end

    def job_element
      '.base-card'
    end

    def job_element_title(job)
      job.search('.base-search-card__title').first.text.strip
    end

    def job_element_location(job)
      job.search('.job-search-card__location').first.text.strip
    end

    def job_element_company(job)
      job.search('.base-search-card__subtitle').first.text.strip
    end

    def job_element_link(job)
      begin
        job.search('.base-card__full-link').first.get_attribute('href')
      rescue
        job.search('.base-search-card__title').first.ancestors('a').first.get_attribute('href')
      end
    end

    def create_job(job, scraped_job_page)
      description = scraped_job_page.search('.show-more-less-html__markup').text

      if field_empty?(job.company)
        company = scraped_job_page.search('.topcard__content-left').search('h3').search('span').first.text.strip
      else
        company = job.company
      end

      new_job = Job.new(
        title: job.title,
        job_link: job.job_link,
        location: job.location,
        description: description,
        source: source,
        status: "scraped",
        company: CompanyServices::FindOrCreateCompany.call(company),
        scraped_company: company,
        source_id: job.job_link
      )

      save_job(new_job, scraped_job_page)
    end

    def javascript
      %{
        (function () {
            setTimeout(function () {
                document.querySelector('.show-more-less-html__button').click()
            }, 3000);
        })();
      }
    end
  end
end
