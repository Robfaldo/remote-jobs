module JobTags
  class RequiresStemDegree < Tag
    def add_tag
      job.requires_stem_degree = true
      job.save!
    end

    def can_handle?
      @title_rule_violations = get_title_violations(rules, job)
      @description_rule_violations = get_description_violations(rules, job)

      @title_rule_violations.count > 0 || @description_rule_violations.count > 0
    end
  end
end
