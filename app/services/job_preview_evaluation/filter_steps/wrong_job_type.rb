module JobPreviewEvaluation
  module FilterSteps
    class WrongJobType < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        filter_job(job_preview, "Rejected for wrong job type in job_preview title. @title_rule_violations: #{@title_rule_violations}.")
      end

      def can_handle?
        @title_rule_violations = get_title_violations(rules, job_preview)

        @title_rule_violations.count > 0
      end
    end
  end
end
