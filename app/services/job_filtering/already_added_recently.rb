module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week. existing_job_links: #{job.job_link}. jobs_with_identical_data, title:  #{job.title}, company: #{job.company}, location: #{job.location}")
      job.tag_list.add(tags_yaml["FilterRules"]["already_added_recently"])
      job.save!
    end

    def can_handle?(job)
      @identical_links_already_filtered = Job.where('created_at >= ?', 1.week.ago).where(job_link: job.job_link).to_a.filter{|job| job.status != "scraped"}
      @identical_data_already_filtered = Job.where('created_at >= ?', 1.week.ago).where(company: job.company, title: job.title, location: job.location).to_a.filter{|job| job.status != "scraped"}

      @identical_links_already_filtered.count > 0 || @identical_data_already_filtered.count > 0
    end
  end
end
