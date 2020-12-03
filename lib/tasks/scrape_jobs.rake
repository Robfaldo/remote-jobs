# require_relative '../../app/services/scraping/scrape_jobs_service.rb'

task :scrape_jobs => :environment do
  jobs = Scraping::ScrapeJobsService.new.call

  CSV.open("log/jobs.csv", 'a') do |csv|
    jobs.each do |job|
      csv << [job.title, job.company, job.link, job.location, job.description, job.source]
    end
  end
end
