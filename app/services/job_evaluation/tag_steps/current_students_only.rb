module JobEvaluation
  module TagSteps
    class CurrentStudentsOnly < ::JobEvaluation::Step
      include ::JobEvaluation::Helpers::TagHelper

      def call
        job.tag_list.add(tags_yaml["Groups"]["current_students_only"])
        job.save!
      end

      def can_handle?
        title_rule_violations = get_title_violations(rules, job)

        title_rule_violations.count > 0
      end
    end
  end
end
