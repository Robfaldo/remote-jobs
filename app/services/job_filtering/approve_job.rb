module JobFiltering
  class ApproveJob < BaseHandler
    private

    def handle(job)
      if job.class == Job
        approve_job(job, message: "Approved: Did not violate any filters")
      elsif job.class == ScrapedJob
        approve_job(job, message: "Approved for scraping")
      end
    end

    def can_handle?(job)
      true
    end
  end
end
