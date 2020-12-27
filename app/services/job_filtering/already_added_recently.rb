module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week. existing_job_links: #{job.job_link}. jobs_with_identical_data, title:  #{job.title}, company: #{job.company}, location: #{job.location}")
    end

    def can_handle?(job)
      @identical_links_already_filtered = Job.where('created_at >= ?', 1.week.ago).where(job_link: job.job_link).to_a.filter{|job| job.status != "scraped"}
      @identical_data_already_filtered = Job.where('created_at >= ?', 1.week.ago).where(company: job.company, title: job.title, location: job.location).to_a.filter{|job| job.status != "scraped"}

      # If there's only 1 then it's the current jobs' one, any more means it's already been added in the last week
      @identical_links_already_filtered.count > 1 || @identical_data_already_filtered.count > 1
    end
  end
end
