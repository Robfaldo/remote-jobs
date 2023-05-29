module ScrapedJobEvaluation
  module FilterSteps
    class WrongJobType < ::ScrapedJobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        filter_job(scraped_job, "Rejected for wrong job type in scraped_job title. @title_rule_violations: #{@title_rule_violations}.")
      end

      def can_handle?
        @title_rule_violations = get_title_violations(rules, scraped_job)

        @title_rule_violations.count > 0
      end
    end
  end
end
