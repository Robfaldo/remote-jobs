task :scrape_jobs do
  SCRAPERS = [
    IndeedScraper
  ]

  jobs = []

  SCRAPERS.each do |scraper|
    jobs << scraper.get_jobs
  end

  require 'pry'; binding.pry
end
