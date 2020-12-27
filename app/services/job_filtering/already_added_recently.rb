module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week, job link: #{job.job_link}")
    end

    def can_handle?(job)
      # If there's only 1 then it's the current jobs' one, any more means it's already been added in the last week
      Job.where('created_at >= ?', 1.week.ago).where(job_link: job.job_link).count > 1
    end
  end
end
