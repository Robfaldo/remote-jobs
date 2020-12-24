require 'simple-rss'
require 'open-uri'

module Scraping
  class StackoverflowScraper < Scraper
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

          new_job = Job.new(
              title: job[:title].split(" at ").first.strip,
              job_link: job[:link],
              location: job[:title].split(" at ")[1].split("(")[1].strip.split(",")[0],
              description: job[:description],
              source: :stackoverflow,
              status: "scraped",
              company: job[:title].split(" at ")[1].split("(")[0].strip,
              job_board: "Stackoverflow",
              source_id: job[:guid]
          )

          new_job.save!
        end
      end
    end
  end
end
