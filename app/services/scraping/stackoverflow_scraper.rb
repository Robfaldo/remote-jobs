require 'simple-rss'
require 'open-uri'

module Scraping
  class StackoverflowScraper < DefaultScraper
    def get_jobs
      search_links.each do |location, data|
        links_to_scrape = Scraping::GetLinksForLocation.call(data)

        links_to_scrape.each do |link|
          jobs_from_rss = SimpleRSS.parse open(link)

          extract_and_save_job(jobs_from_rss, location)
        end
      end
    end

    private

    def extract_and_save_job(jobs_from_rss, searched_location)
      jobs_from_rss.items.each do |job|
        unless Job.where(source_id: job[:guid]).count > 0

          scraped_company = job[:title].split(" at ")[1].split("(")[0].strip

          new_job = Job.new(
              title: job[:title].split(" at ").first.strip,
              job_link: job[:link],
              location: job[:title].split(" at ")[1].split("(")[1].strip.split(",")[0],
              description: job[:description],
              source: :stackoverflow,
              status: "scraped",
              company: FindOrCreateCompany.call(scraped_company),
              scraped_company: scraped_company,
              job_board: "Stackoverflow",
              source_id: job[:guid],
              searched_location: searched_location
          )

          save_job(new_job)
        end
      end
    end
  end
end
