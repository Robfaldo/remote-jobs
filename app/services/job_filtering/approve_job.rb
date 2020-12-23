module JobFiltering
  class ApproveJob < BaseHandler
    private

    def handle(job)
      approve_job(job, message: "Approved: Did not violate any filters")
    end

    def can_handle?(job)
      true
    end
  end
end