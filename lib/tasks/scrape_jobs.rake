task :scrape_jobs => :environment do
  if Rails.env.development?
    process
  else
    current_hour = Time.now.in_time_zone('London').hour
    process if current_hour >= 8 && current_hour < 19
  end
end

def process
  Scraping::ScrapeJobsService.new.call

  JobFiltering::FilterJobs.new(Job.where(status: "scraped")).call

  JobTags::TagJobs.new(Job.where(status: "scraped")).call

  ScrapedJob.created_over_n_days(3).all.destroy_all
end
