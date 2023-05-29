module JobEvaluation
  module FilterSteps
    class WrongJobType < ::JobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        filter_job_for_title_or_description_violations(@title_rule_violations, @description_rule_violations, job, class_name_underscored.to_sym)
      end

      def can_handle?
        @title_rule_violations = get_title_violations(rules, job)

        @description_rule_violations = get_description_violations(rules, job)

        @title_rule_violations.count > 0 || @description_rule_violations.count > 0
      end

      private


      def filter_job_for_title_or_description_violations(title_rule_violations, description_rule_violations, job, filter)
        job.filtered = true

        if title_rule_violations.count > 0
          job.status_reason = "" unless job.status_reason
          job.status_reason << "Wrong job type: Title violated the #{filter} filter_steps - rule(s) violated were: #{title_rule_violations}."
        end

        if description_rule_violations.count > 0
          job.status_reason = "" unless job.status_reason
          job.status_reason << "Wrong job type: Description violated the #{filter} filter_steps - rule(s) violated were: #{description_rule_violations}."
        end

        job.save!
      end
    end
  end
end

