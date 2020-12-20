task :scrape_jobs => :environment do
  CSV.open(Rails.root.join("lib/jobs.csv"), 'a') # if file does not exist then create it

  jobs = Scraping::ScrapeJobsService.new.call

  CSV.open(Rails.root.join("lib/jobs.csv"), 'a') do |csv|
    jobs.each do |job|
      csv << [job.title || "none", job.company || "none", job.link || "none", job.location || "none", job.description || "none", job.job_board || "none", job.source || "none", job.source_id || "none"]
    end
  end
end
