module JobPreviewEvaluation
  module FilterSteps
    class BlackList < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      FILTER_REASON = :blacklist

      def call
        reject_message = %{
          Black listed: @black_list_link_violations: #{@black_list_link_violations}.
          @black_list_company_violations: #{@black_list_company_violations}.
        }

        filter_job(job_preview, reject_message)
      end

      def can_handle?
        @black_list_link_violations = rules["url"].filter { |rule| job_preview.url.downcase.include?(rule.downcase.strip) }
        @black_list_company_violations = []

        if job_preview.company
          @black_list_company_violations = rules["company"].filter { |rule| job_preview.company.downcase.strip.include?(rule.downcase.strip) }
        end

        @black_list_link_violations.count > 0 || @black_list_company_violations.count > 0
      end
    end
  end
end
