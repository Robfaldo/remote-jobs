require 'simple-rss'
require 'open-uri'

module Scraping
  class StackoverflowScraper < Scraper
    def get_jobs
      jobs_from_rss = SimpleRSS.parse open('http://stackoverflow.com/jobs/feed?l=London%2c+UK&u=Miles&d=20&ms=Student&mxs=Junior')

      jobs = []

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

          jobs.push(new_job)
        end
      end

      [:stackoverflow, jobs.count]
    end
  end
end
