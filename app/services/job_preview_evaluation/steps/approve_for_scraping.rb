module JobPreviewEvaluation
  module Steps
    class ApproveForScraping < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        job_preview.status = "approved"
        job_preview.status_reason = "Approved for scraping"
        job_preview.save!
      end

      def can_handle?
        true
      end
    end
  end
end
