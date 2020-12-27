module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week. existing_job_links: #{@existing_job_links}. jobs_with_identical_data: #{@jobs_with_identical_data}")
    end

    def can_handle?(job)
      @existing_job_links = Job.where('created_at >= ?', 1.week.ago).where(job_link: job.job_link)
      @jobs_with_identical_data = Job.where('created_at >= ?', 1.week.ago).where(company: job.company, title: job.title, location: job.location)

      # If there's only 1 then it's the current jobs' one, any more means it's already been added in the last week
      @existing_job_links.count > 1 || @jobs_with_identical_data.count > 1
    end
  end
end
