module ScrapedJobEvaluation
  module FilterSteps
    class BlackList < ::ScrapedJobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        reject_message = %{
          Black listed: @black_list_link_violations: #{@black_list_link_violations}.
          @black_list_company_violations: #{@black_list_company_violations}.
        }

        filter_job(scraped_job, reject_message)
      end

      def can_handle?
        @black_list_link_violations = rules["job_link"].filter { |rule| scraped_job.job_link.downcase.include?(rule.downcase.strip) }
        @black_list_company_violations = []

        if scraped_job.company
          @black_list_company_violations = rules["company"].filter { |rule| scraped_job.company.downcase.strip.include?(rule.downcase.strip) }
        end

        @black_list_link_violations.count > 0 || @black_list_company_violations.count > 0
      end
    end
  end
end
