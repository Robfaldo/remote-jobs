module JobFiltering
  class TitleRequirements < BaseHandler
    def meets_title_requirements?(job)
      can_handle?(job) == false
    end

    private

    def handle(job)
      reject_job(job, "Rejected for missing title requirements. Levels matched: #{@levels_matched}. Roles matched: #{@roles_matched}. Software indicators matched: #{@software_indicators_matched}")
    end

    def can_handle?(job)
      @levels_matched = rules["level"].filter { |rule| job.title.downcase.include?(rule.downcase) }
      @roles_matched = rules["role"].filter { |rule| job.title.downcase.include?(rule.downcase) }
      @software_indicators_matched = rules["software_indicator"].filter { |rule| job.title.downcase.include?(rule.downcase) }

      @levels_matched.count == 0 || @roles_matched.count == 0 || @software_indicators_matched.count == 0
    end
  end
end