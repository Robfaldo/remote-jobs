task :scrape_jobs => :environment do
  Scraping::ScrapeJobsService.new.call

  JobFiltering::FilterJobs.new(Job.where(status: "scraped")).call

  JobTags::TagJobs.new(Job.where(status: "scraped")).call

  ScrapedJob.created_over_n_days(3).all.destroy_all
end
