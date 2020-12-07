require 'simple-rss'
require 'open-uri'

module Scraping
  class StackoverflowScraper < Scraper
    def get_jobs
      jobs_from_rss = SimpleRSS.parse open('http://stackoverflow.com/jobs/feed?l=London%2c+UK&u=Miles&d=20&ms=Student&mxs=Junior')

      parsed_jobs_csv = CSV.parse(File.read("log/jobs.csv"))
      saved_source_ids = parsed_jobs_csv.map{|row| row[6]}

      jobs = []

      jobs_from_rss.items.each do |job|
        unless saved_source_ids.include? job[:guid]
          jobs.push(
            ScrapedJob.new(
              title: job[:title].split(" at ").first.strip,
              company: job[:title].split(" at ")[1].split("(")[0].strip,
              link: job[:link],
              location: job[:title].split(" at ")[1].split("(")[1].strip.split(",")[0],
              description: job[:description],
              source: :stackoverflow,
              source_id: job[:guid]
            )
          )
        end
      end

      jobs
    end
  end
end
