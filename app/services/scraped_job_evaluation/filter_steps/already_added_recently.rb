module ScrapedJobEvaluation
  module FilterSteps
    class AlreadyAddedRecently < ::ScrapedJobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        filter_job(scraped_job, message: "Rejected: scraped_job has already been added within 1 week. #{@identical_jobs.uniq.map{|j| { id: j.id, link: j.job_link } }}")
      end

      def can_handle?
        identical_links_already_approved = Job.created_last_week.where(job_link: scraped_job.job_link)
        existing_company = CompanyServices::FindCompany.call(scraped_job.company)

        matches_for_company_and_title =
          Job.created_last_week
             .where(company: existing_company)
             .where("lower(title) LIKE ?", "#{scraped_job.title.downcase.strip}%")

        @identical_jobs = identical_links_already_approved.to_ary.concat(matches_for_company_and_title.to_ary)

        matches_for_company_and_title.count > 0 || identical_links_already_approved.count > 0
      end
    end
  end
end
