module JobFiltering
  class EnsureJobTypeAllowed < BaseHandler
    private

    def handle(job)
      reject_message = "Rejected because job title/description didn't meet requirements for any job type."

      reject_job(job, reject_message)

      if job.class == Job
        job.tag_list.add(tags_yaml["FilterRules"]["does_not_meet_any_job_type"])
      end

      job.save!
    end

    def can_handle?(job)
      if job.class == ScrapedJob
        is_a_developer = JobEvaluators::CheckIfDeveloperJob.check_title_only(job)
      else
        is_a_developer = JobEvaluators::CheckIfDeveloperJob.check_title_and_description(job)
      end

      is_an_allowed_job_type = is_a_developer # || is_a_devops_engineer || is_a_recruiter

      # If it's not an allowed job type then we want to filter it out
      return true unless is_an_allowed_job_type
    end
  end
end
