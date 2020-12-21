task :scrape_jobs => :environment do
  CSV.open(Rails.root.join("lib/scraping_summary.csv"), 'a') # if file does not exist then create it

  scraping_summaries = Scraping::ScrapeJobsService.new.call

  CSV.open(Rails.root.join("lib/scraping_summary.csv"), 'a') do |csv|
    scraping_summaries.each do |summary|
      csv << [Date.today.to_formatted_s(:long), summary[0], summary[1]]
    end
  end
end
