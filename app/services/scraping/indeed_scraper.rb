require_relative './scraper.rb'
require_relative '../../models/scraped_job.rb'

module Scraping
  class IndeedScraper < Scraper
    INITIAL_SEARCH_URL = "https://www.indeed.co.uk/jobs?q=title%3A%28frontend+or+%22front+end%22+or+%22front-end%22+or+fullstack+or+%22full+stack%22+or+%22full-stack%22+or+backend+or+%22back+end%22+or+%22back-end%22+or+software+or+web+OR+javascript+OR+react+or+vue+or+angular+OR+python+OR+java+OR+ruby+OR+node+or+%E2%80%9Cc%23%E2%80%9D+or+%E2%80%9Cc%2B%2B%E2%80%9D+or+Clojure+or+elixir+or+elm+or+go+or+groovy+or+Haskell+or+kotlin+or+perl+or+php+or+Scala+or+swift+or+typescript+or+Django+or+c+or+rails+or+Laravel+or+%E2%80%9C.net%E2%80%9D+or+flask%29+AND+title%3A%28junior+or+entry%29+AND+title%3A%28%22developer%22+or+development+or+%22engineer%22+or+engineering%29&l=London&radius=10&fromage=1"
    # INITIAL_SEARCH_URL = "https://www.indeed.co.uk/jobs?q=retinal&l=Ware+SG12&radius=5&fromage=1%22"

    def get_jobs(url: INITIAL_SEARCH_URL)
      initial_page = scrape(url)

      parse_data(initial_page)
    end

    private

    def parse_data(parsed_page)
      job_cards = parsed_page.search(".jobsearch-SerpJobCard")

      jobs = []

      job_cards.each do |job|
        title = job.search(".title").text.strip.gsub("\n\nnew", "")
        company = job.search(".company").text.strip
        job_link = "https://www.indeed.co.uk" + job.search(".jobtitle").first.attributes["href"].value
        location = job.search(".location").text.strip
        jobs.push(
          ScrapedJob.new(
            title: title,
            company: company,
            link: job_link,
            location: location,
            description: job_description(job_link),
            source: :indeed
          )
        )
      end

      jobs.uniq # It looked like it sometimes duplicated the jobs. Haven't debugged properly yet
    end

    def job_description(link)
      page = scrape(link)

      page.search(".jobsearch-jobDescriptionText").text
    end
  end
end
