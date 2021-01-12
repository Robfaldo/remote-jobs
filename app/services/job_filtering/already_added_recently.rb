module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week. @identical_links_already_approved: #{@identical_links_already_approved.to_ary}. @identical_description_already_approved: #{@identical_description_already_approved.to_ary}. @identical_data_already_approved: #{@identical_data_already_approved.to_ary}")
      job.tag_list.add(tags_yaml["FilterRules"]["already_added_recently"])
      # job.reviewed = true # There's so many of these and I always just mark as reviewed, might aswell just save the effort and mark reviewed here
      job.save!
    end

    def can_handle?(job)
      @identical_links_already_approved = Job.where('created_at >= ?', 1.week.ago).where(job_link: job.job_link, status: 'approved')
      @identical_description_already_approved = Job.where('created_at >= ?', 1.week.ago).where(description: job.description, status: 'approved')
      @identical_data_already_approved = Job.where('created_at >= ?', 1.week.ago).where(title: job.title, company: job.company, status: 'approved')

      @identical_links_already_approved.count > 0 || @identical_description_already_approved.count > 0 || @identical_data_already_approved.count > 0
    end
  end
end
