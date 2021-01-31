module JobFiltering
  class AlreadyAddedRecently < BaseHandler
    private

    def handle(job)
      reject_job(job, message: "Rejected: Job link has already been added within 1 week.")
      job.tag_list.add(tags_yaml["FilterRules"]["already_added_recently"])
      job.reviewed = true # There's so many of these and I always just mark as reviewed, might aswell just save the effort and mark reviewed here
      job.save!
    end

    def can_handle?(job)
      Job.recently_added?(job)
    end
  end
end
