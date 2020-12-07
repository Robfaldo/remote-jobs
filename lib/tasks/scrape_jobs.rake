task :scrape_jobs => :environment do
  CSV.open(Rails.root.join("lib/jobs.csv"), 'a') # if file does not exist then create it
  puts "File exists?:"
  puts File.exist?(Rails.root.join('lib/jobs.csv'))

  jobs = Scraping::ScrapeJobsService.new.call

  puts "jobs before adding them to the csv: "

  CSV.open(Rails.root.join("lib/jobs.csv"), 'a') do |csv|
    jobs.each do |job|
      csv << [job.title, job.company, job.link, job.location, job.description, job.source, job.source_id || "none"]
    end
  end

  puts "File output: "
  puts File.read(Rails.root.join('lib/jobs.csv'))
end
