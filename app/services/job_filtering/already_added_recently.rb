module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week.")

      if job.class == Job
        job.tag_list.add(tags_yaml["FilterRules"]["already_added_recently"])
        job.reviewed = true
      end

      job.save!
    end

    def can_handle?(job)
      identical_links_already_approved = Job.created_last_week.where(job_link: job.job_link)

      identical_data_already_approved = Job.created_last_week.select do |database_job|
        company_matches(database_job, job) && title_matches(database_job, job)
      end

      if job.class == ScrapedJob
        # we won't have a description to check, and any matches of actual jobs (i.e. Jobs, not JobsToEvaluate) means there's duplicates
        identical_links_already_approved.count > 0 || identical_data_already_approved.count > 0
      else
        identical_description_already_approved = Job.created_last_week.where(description: description)

        # over 1 because the Job has already been saved (we run this service after scraping & saving jobs) so there will be 1 matching already, any more means there's duplicates.
        identical_links_already_approved.count > 1 || identical_description_already_approved.count > 1 || identical_data_already_approved.count > 1
      end
    end

    def company_matches(database_job, job)
      return false unless job.company

      database_job.company.downcase.strip.gsub(' ltd', '') == job.company.downcase.strip.gsub(' ltd', '')
    end

    def title_matches(database_job, job)
      database_job.title.downcase.strip == job.title.downcase.strip
    end
  end
end
