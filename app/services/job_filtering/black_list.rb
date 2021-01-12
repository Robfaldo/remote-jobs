module JobFiltering
  class BlackList < BaseHandler
    private

    def handle(job)
      reject_job(job,"Black listed: @black_list_link_violations: #{@black_list_link_violations}. @black_list_company_violations: #{@black_list_company_violations}. @black_list_description_violations: #{@black_list_description_violations}")
      job.tag_list.add(tags_yaml["FilterRules"]["black_listed"])

      job.save!
    end

    def can_handle?(job)
      @black_list_link_violations = rules["job_link"].filter { |rule| job.job_link.downcase.include?(rule.downcase.strip) }
      @black_list_company_violations = rules["company"].filter { |rule| job.company.downcase.strip.include?(rule.downcase.strip) }
      @black_list_description_violations = rules["description"].filter { |rule| job.description.downcase.include?(rule.downcase.strip) }

      @black_list_link_violations.count > 0 || @black_list_company_violations.count > 0 || @black_list_description_violations.count > 0
    end
  end
end