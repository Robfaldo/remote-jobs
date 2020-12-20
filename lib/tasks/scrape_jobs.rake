task :scrape_jobs => :environment do
  jobs = Scraping::ScrapeJobsService.new.call
end
