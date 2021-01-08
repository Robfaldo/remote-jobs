task :scrape_jobs => :environment do
  Scraping::ScrapeJobsService.new.call

  JobTags::TagJobs.new(Job.where(status: "scraped")).call

  JobFiltering::FilterJobs.new(Job.where(status: "scraped")).call
end
