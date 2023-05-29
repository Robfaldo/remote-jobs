module ScrapedJobEvaluation
  module FilterSteps
    class EnsureJobTypeAllowed < ::ScrapedJobEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        reject_message = "Rejected because scraped_job title/description didn't meet requirements for any job type."

        filter_job(scraped_job, reject_message)
      end

      def can_handle?
        is_a_developer = JobEvaluators::CheckIfDeveloperJob.check_title_only(scraped_job)

        is_an_allowed_job_type = is_a_developer # || is_a_devops_engineer || is_a_recruiter

        # If it's not an allowed job type then we want to filter it out
        return true unless is_an_allowed_job_type
      end
    end
  end
end
