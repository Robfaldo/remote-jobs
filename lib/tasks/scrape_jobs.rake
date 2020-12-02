require_relative '../../app/services/scraping/scrape_jobs_service.rb'

task :scrape_jobs do
  jobs = Scraping::ScrapeJobsService.new.call
end
