module ScrapedJobEvaluation
  module Steps
    class ApproveForScraping < ::ScrapedJobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        scraped_job.status = "approved"
        scraped_job.status_reason = "Approved for scraping"
        scraped_job.save!
      end

      def can_handle?
        true
      end
    end
  end
end
