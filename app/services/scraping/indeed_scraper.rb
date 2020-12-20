require 'simple-rss'
require 'open-uri'

module Scraping
  class IndeedScraper < Scraper
    def get_jobs
      jobs_from_rss = SimpleRSS.parse open('https://www.indeed.co.uk/rss?q=software+developer&l=London')

      jobs = []

      jobs_from_rss.items.each do |job|
        unless Job.where(source_id: job[:guid]).count > 0
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
              job_board: 'Indeed',
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
      page = scrape_page(link: link)

      page.search(".jobsearch-jobDescriptionText").text
    end
  end
end
