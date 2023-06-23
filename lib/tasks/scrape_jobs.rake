task :scrape_jobs => :environment do
  if Rails.env.development?
    process
  else
    current_hour = Time.now.in_time_zone('London').hour
    process if within_live_hour_scraping_window(current_hour) && current_hour.even?
  end
end

def within_live_hour_scraping_window(current_hour)
  current_hour >= 8 && current_hour < 19
end

def process
  Scraping::ScrapeJobBoards.new.call

  JobEvaluation::Pipeline.new(Job.where(status: "scraped")).process

  JobPreview.created_over_n_days(3).all.destroy_all
end
