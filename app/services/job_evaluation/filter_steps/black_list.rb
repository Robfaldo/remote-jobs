module JobEvaluation
  module FilterSteps
    class BlackList < ::JobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        filter_message = %{
          Black listed: @black_list_link_violations: #{@black_list_link_violations}.
          @black_list_company_violations: #{@black_list_company_violations}.
        }
        filter_message << "@black_list_description_violations: #{@black_list_description_violations}" if job.class == Job
        2
        filter_job(job, filter_message)
      end

      def can_handle?
        @black_list_link_violations = rules["url"].filter { |rule| job.url.downcase.include?(rule.downcase.strip) }
        @black_list_company_violations = rules["company"].filter { |rule| job.scraped_company.downcase.strip.include?(rule.downcase.strip) }
        @black_list_description_violations = rules["description"].filter { |rule| job.description.downcase.include?(rule.downcase.strip) }

        @black_list_description_violations.count > 0 || @black_list_link_violations.count > 0 || @black_list_company_violations.count > 0
      end
    end
  end
end
