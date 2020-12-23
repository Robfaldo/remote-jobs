module JobFiltering
  class RequiresExperience < BaseHandler
    private

    def handle(job)
      reject_job_for_title_or_description_violations(@title_rule_violations, @description_rule_violations, job, class_name_underscored.to_sym)
    end

    def can_handle?(job)
      @title_rule_violations = get_title_violations(rules, job)
      @description_rule_violations = get_description_violations(rules, job)

      @title_rule_violations.count > 0 || @description_rule_violations.count > 0
    end
  end
end