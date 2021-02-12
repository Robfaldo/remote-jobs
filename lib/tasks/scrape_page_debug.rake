task :debug_page => :environment do
  include ScrapingHelper

  link = 'https://uk.linkedin.com/jobs/view/graduate-python-developer-at-graduate-launchpad-2419951590?refId=746ba261-d7d0-42d1-a594-f23e9850e6e4&trackingId=OfltzTUEB2qfKZoTyCZVnw%3D%3D&position=24&pageNum=0&trk=public_jobs_job-result-card_result-card_full-click'

  options = {
    link: link,
    wait_time: 6000,
    premium_proxy: true
  }

  scraped_page = Scraping::Scraper.new.scrape_page(options)
  binding.pry
end
