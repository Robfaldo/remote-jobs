task :scrape_jobs => :environment do
  Scraping::ScrapeJobsService.new.call

  JobFiltering::FilterJobs.new(
    Job.where(status: "scraped")
  ).call
end
