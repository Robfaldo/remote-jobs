module JobEvaluation
  module TagSteps
    class RequiresStemDegree < ::JobEvaluation::Step
      include ::JobEvaluation::Helpers::TagHelper

      def call
        job.tag_list.add(tags_yaml["JobTags"]["requires_stem_degree"])
        job.save!
      end

      def can_handle?
        @title_rule_violations = get_title_violations(rules, job)
        @description_rule_violations = get_description_violations(rules, job)

        @title_rule_violations.count > 0 || @description_rule_violations.count > 0
      end
    end
  end
end
