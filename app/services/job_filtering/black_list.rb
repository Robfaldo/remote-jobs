module JobFiltering
  class BlackList < BaseHandler
    private

    def handle(job)
      reject_message = %{
        Black listed: @black_list_link_violations: #{@black_list_link_violations}.
        @black_list_company_violations: #{@black_list_company_violations}.
      }
      reject_message << "@black_list_description_violations: #{@black_list_description_violations}" if job.class == Job

      reject_job(job, reject_message)

      if job.class == Job
        job.tag_list.add(tags_yaml["FilterRules"]["black_listed"])
        job.reviewed = true
      end

      job.save!
    end

    def can_handle?(job)
      @black_list_link_violations = rules["job_link"].filter { |rule| job.job_link.downcase.include?(rule.downcase.strip) }
      @black_list_company_violations = []

      if job.class == ScrapedJob
        if job.company
          @black_list_company_violations = rules["company"].filter { |rule| job.company.downcase.strip.include?(rule.downcase.strip) }
        end
      elsif job.class == Job
        if job.scraped_company
          @black_list_company_violations = rules["company"].filter { |rule| job.scraped_company.downcase.strip.include?(rule.downcase.strip) }
        end

        @black_list_description_violations = rules["description"].filter { |rule| job.description.downcase.include?(rule.downcase.strip) }

        return true if @black_list_description_violations.count > 0
      end

      @black_list_link_violations.count > 0 || @black_list_company_violations.count > 0
    end
  end
end
