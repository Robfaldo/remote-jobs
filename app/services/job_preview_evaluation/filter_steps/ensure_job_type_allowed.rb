module JobPreviewEvaluation
  module FilterSteps
    class EnsureJobTypeAllowed < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      def call
        reject_message = "Rejected because job_preview title/description didn't meet requirements for any job type."

        filter_job(job_preview, reject_message)
      end

      def can_handle?
        is_a_developer = JobEvaluators::CheckIfDeveloperJob.check_title_only(job_preview)

        is_an_allowed_job_type = is_a_developer # || is_a_devops_engineer || is_a_recruiter

        # If it's not an allowed job type then we want to filter it out
        return true unless is_an_allowed_job_type
      end
    end
  end
end
