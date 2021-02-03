module JobFiltering
  class WrongJobType < BaseHandler
    private

    def handle(job)
      if job.class == Job
        reject_job_for_title_or_description_violations(@title_rule_violations, @description_rule_violations, job, class_name_underscored.to_sym)
        job.tag_list.add(tags_yaml["FilterRules"]["wrong_job_type"])
      elsif job.class == ScrapedJob
        reject_job(job, "Rejected for wrong job type in job title. @title_rule_violations: #{@title_rule_violations}.")
      end

      job.save!
    end

    def can_handle?(job)
      @title_rule_violations = get_title_violations(rules, job)

      if job.class == ScrapedJob
        return @title_rule_violations.count > 0
      else
        @description_rule_violations = get_description_violations(rules, job)

        @title_rule_violations.count > 0 || @description_rule_violations.count > 0
      end
    end
  end
end
