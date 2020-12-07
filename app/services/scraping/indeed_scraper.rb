require 'simple-rss'
require 'open-uri'

module Scraping
  class IndeedScraper < Scraper
    # INITIAL_SEARCH_URL = "https://www.indeed.co.uk/jobs?q=title%3A%28frontend+or+%22front+end%22+or+%22front-end%22+or+fullstack+or+%22full+stack%22+or+%22full-stack%22+or+backend+or+%22back+end%22+or+%22back-end%22+or+software+or+web+OR+javascript+OR+react+or+vue+or+angular+OR+python+OR+java+OR+ruby+OR+node+or+%E2%80%9Cc%23%E2%80%9D+or+%E2%80%9Cc%2B%2B%E2%80%9D+or+Clojure+or+elixir+or+elm+or+go+or+groovy+or+Haskell+or+kotlin+or+perl+or+php+or+Scala+or+swift+or+typescript+or+Django+or+c+or+rails+or+Laravel+or+%E2%80%9C.net%E2%80%9D+or+flask%29+AND+title%3A%28junior+or+entry%29+AND+title%3A%28%22developer%22+or+development+or+%22engineer%22+or+engineering%29&l=London&radius=10&fromage=1"

    def get_jobs
      puts "Reaches Indeed scraper get_jobs"
      jobs_from_rss = SimpleRSS.parse open('https://www.indeed.co.uk/rss?q=software+developer&l=London')

      parsed_jobs_csv = CSV.parse(File.read("log/jobs.csv"))
      saved_source_ids = parsed_jobs_csv.map{|row| row[6]}

      jobs = []

      jobs_from_rss.items.each do |job|
        unless saved_source_ids.include? job[:guid]
          link = CGI::unescapeHTML(job[:link])
          scraped_description = scrape_job_description(link)
          rss_title = CGI::unescapeHTML(job[:title])

          jobs.push(
            ScrapedJob.new(
              title: rss_title.split(" - ")[0],
              company: rss_title.split(" - ")[1],
              link: link,
              location: rss_title.split(" - ")[2].split(', ')[0],
              description: scraped_description,
              source: :indeed,
              source_id: job[:guid]
            )
          )
        end
      end

      jobs
    end

    private

    def scrape_job_description(link)
      page = scrape(link)

      page.search(".jobsearch-jobDescriptionText").text
    end
  end
end
