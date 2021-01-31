module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    def recently_added?(job)
      can_handle?(job)
    end

    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week.")
      job.tag_list.add(tags_yaml["FilterRules"]["already_added_recently"])
      job.reviewed = true # There's so many of these and I always just mark as reviewed, might aswell just save the effort and mark reviewed here
      job.save!
    end

    def can_handle?(job)
      if job.class == JobToEvaluate
        job_link = job.link
        description = nil
      else
        job_link = job.job_link
        description = job.description
      end

      identical_links_already_approved = Job.created_last_week.where(job_link: job_link)
      identical_description_already_approved = Job.created_last_week.where(description: description)

      identical_data_already_approved = Job.created_last_week.select do |database_job|
        company_matches(database_job, job) && title_matches(database_job, job)
      end

      identical_links_already_approved.count > 0 || identical_description_already_approved.count > 0 || identical_data_already_approved.count > 0
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
