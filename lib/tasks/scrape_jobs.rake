task :scrape_jobs => :environment do
  Scraping::ScrapeJobsService.new.call
end
