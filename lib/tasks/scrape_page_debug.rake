task :debug_page => :environment do
  include ScrapingHelper

  link = 'https://uk.indeed.com/jobs?q=software+AND+%28developer+OR+engineer%29&l=London&radius=15&fromage=1&sort=date'

  options = {
    link: link,
    wait_time: 10000,
    premium_proxy: true
  }

  scraped_page = Scraping::ScrapePage.call(**options)
  # save_page(scraped_page)
  binding.pry
end
