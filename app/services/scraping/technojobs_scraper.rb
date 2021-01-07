require 'simple-rss'
require 'open-uri'

module Scraping
  class TechnojobsScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          jobs_from_rss = SimpleRSS.parse open(link.gsub(' ', '%20'))

          jobs_to_evaluate = jobs_to_evaluate(jobs_from_rss)

          jobs_to_scrape = evaluate_jobs(jobs_to_evaluate)

          extract_and_save_job(jobs_to_scrape)
        end
      end
    end

    private

    def jobs_to_evaluate(scraped_all_jobs_page)
      jobs_to_evaluate = []

      scraped_all_jobs_page.items.each do |job|

        begin
          job_to_evaluate = extract_job_to_evaluate(job)

          jobs_to_evaluate.push(job_to_evaluate)
        rescue => e
          Rollbar.error(e)
        end
      end

      jobs_to_evaluate
    end

    def extract_job_to_evaluate(job)
      title = job[:title]
      link = job[:link]

      JobToEvaluate.new(title: title, link: link)
    end

    def extract_and_save_job(evaluated_jobs)
      evaluated_jobs.each do |job|
        unless Job.where(source_id: job.link).count > 0
          scraped_job_page = scrape_page(link: job.link)

          job_summary_rows = scraped_job_page.search('.job-listing-table').first.search('tbody').search('tr')
          company = job_summary_rows.to_a.filter{|row| row.text.include?('Recruiter:')}.first.text.gsub('Recruiter:', '').strip
          location = job_summary_rows.to_a.filter{|row| row.text.include?('Location:')}.first.text.gsub('Location:', '').strip
          description = scraped_job_page.search('.job-listing-body').first.text

          new_job = Job.new(
              title: job.title,
              job_link: job.link,
              location: location,
              description: description,
              source: :technojobs,
              status: "scraped",
              company: company,
              job_board: "technojobs",
              source_id: job.link
          )

          new_job.save!
        end
      end
    end
  end
end
