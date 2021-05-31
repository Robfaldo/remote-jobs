module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job has already been added within 1 week. #{@identical_jobs.map{|j| { id: j.id, link: j.job_link } }}")

      if job.class == Job
        job.tag_list.add(tags_yaml["FilterRules"]["already_added_recently"])
        job.reviewed = true
      end

      job.save!
    end

    def can_handle?(job)
      identical_links_already_approved = Job.created_last_week.where(job_link: job.job_link)

      if job.class == ScrapedJob
        existing_company = CompanyServices::FindCompany.call(job.company)

        matches_for_company_and_title =
          Job.created_last_week
             .where(company: existing_company)
             .where("lower(title) LIKE ?", "#{job.title.downcase.strip}%")

        @identical_jobs = identical_links_already_approved.to_ary.concat(matches_for_company_and_title.to_ary)

        return true if matches_for_company_and_title.count > 0 || identical_links_already_approved.count > 0
      elsif job.class == Job
        identical_description_already_approved = Job.created_last_week.where(description: job.description)

        matches_for_company_and_title =
          Job.created_last_week
             .where(company: job.company)
             .where("lower(title) LIKE ?", "#{job.title.downcase.strip}%")

        @identical_jobs = identical_links_already_approved.to_ary.concat(matches_for_company_and_title.to_ary).concat(identical_description_already_approved.to_ary)

        # over 1 because the Job has already been saved (we run this service after scraping & saving jobs) so there will be 1 matching already, any more means there's duplicates.
        identical_links_already_approved.count > 1 || identical_description_already_approved.count > 1 || matches_for_company_and_title.count > 1
      end
    end
  end
end
