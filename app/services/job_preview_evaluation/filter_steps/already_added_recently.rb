module JobPreviewEvaluation
  module FilterSteps
    class AlreadyAddedRecently < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      FILTER_REASON = :already_added_recently

      def call
        filter_job(job_preview, message: "Rejected: job_preview has already been added within 1 week. #{@identical_jobs.uniq.map{|j| { id: j.id, link: j.url } }}")
      end

      def can_handle?
        identical_links_already_approved = Job.created_last_week.where(url: job_preview.url)
        existing_company = CompanyServices::FindCompany.call(job_preview.company)

        matches_for_company_and_title =
          Job.created_last_week
             .where(company: existing_company)
             .where("lower(title) LIKE ?", "#{job_preview.title.downcase.strip}%")

        @identical_jobs = identical_links_already_approved.to_ary.concat(matches_for_company_and_title.to_ary)

        matches_for_company_and_title.count > 0 || identical_links_already_approved.count > 0
      end
    end
  end
end
