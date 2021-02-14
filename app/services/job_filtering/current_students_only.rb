module JobFiltering
  class CurrentStudentsOnly < BaseHandler
    private

    def handle(job)
      reject_job(job, @title_rule_violations)
      job.tag_list.add(tags_yaml["FilterRules"]["current_students_only"])
      job.save!
    end

    def can_handle?(job)
      @title_rule_violations = get_title_violations(rules, job)

      @title_rule_violations.count > 0
    end
  end
end
