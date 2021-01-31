module JobFiltering
  class WrongJobType < BaseHandler
    def wrong_job_title?(job)
      title_rule_violations = get_title_violations(rules, job)

      title_rule_violations.count > 0
    end

    private

    def handle(job)
      reject_job_for_title_or_description_violations(@title_rule_violations, @description_rule_violations, job, class_name_underscored.to_sym)
      job.tag_list.add(tags_yaml["FilterRules"]["wrong_job_type"])
      job.save!
    end

    def can_handle?(job)
      @title_rule_violations = get_title_violations(rules, job)
      @description_rule_violations = get_description_violations(rules, job)

      @title_rule_violations.count > 0 || @description_rule_violations.count > 0
    end
  end
end
