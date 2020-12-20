module Scraping
  class ScrapeJobsService
    SCRAPERS = [
      Scraping::GoogleScraper,
      Scraping::IndeedScraper,
      Scraping::StackoverflowScraper
    ]

    def call
      jobs = []

      SCRAPERS.each do |scraper|
        new_jobs = scraper.new.get_jobs

        jobs.concat(new_jobs)
      end

      jobs.each do |job|
        next if Job.where(job_link: job.link).count > 0

        new_job = Job.new(
          title: job.title,
          job_link: job.link,
          location: job.location,
          description: job.description,
          source: job.source,
          status: "scraped",
          company: job.company
        )

        new_job.source_id = job.source_id if job.source_id
        new_job.job_board = job.job_board if job.job_board

        new_job.save!
      end
    end
  end
end
