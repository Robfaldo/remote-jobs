require 'simple-rss'
require 'open-uri'

module Scraping
  class IndeedScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          jobs_from_rss = SimpleRSS.parse open(link)

          extract_and_save_job(jobs_from_rss)
        end
      end
    end

    private

    def extract_and_save_job(jobs_from_rss)
      jobs_from_rss.items.each do |job|
        unless Job.where(source_id: job[:guid]).count > 0
          link = CGI::unescapeHTML(job[:link])
          scraped_description = scrape_job_description(link)
          rss_title = CGI::unescapeHTML(job[:title])

          new_job = Job.new(
              title: rss_title.split(" - ")[0],
              job_link: link,
              location: rss_title.split(" - ")[2].split(', ')[0],
              description: scraped_description,
              source: :indeed,
              status: "scraped",
              company: rss_title.split(" - ")[1],
              job_board: "Indeed",
              source_id: job[:guid]
          )

          new_job.save!
        end
      end
    end

    def scrape_job_description(link)
      page = scrape_page(link: link)

      page.search(".jobsearch-jobDescriptionText").text
    end
  end
end
