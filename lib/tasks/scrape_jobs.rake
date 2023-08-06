task :scrape_jobs => :environment do
  process

  # Commenting this out in case i change my mind but i'm changing the scraper for job boards to once a day
  # if Rails.env.development?
  #   process
  # else
  #   current_hour = Time.now.in_time_zone('London').hour
  #   process if within_live_hour_scraping_window(current_hour) && current_hour.even?
  # end
end

def within_live_hour_scraping_window(current_hour)
  current_hour >= 8 && current_hour < 19
end

def process
  Scraping::ScrapeJobBoards.new.call

  jobs = Job.where(status: "scraped").where.not(source: "direct_from_careers_page")
  JobEvaluation::Pipeline.new(jobs).process

  JobPreview.created_over_n_days(3).all.destroy_all
end
