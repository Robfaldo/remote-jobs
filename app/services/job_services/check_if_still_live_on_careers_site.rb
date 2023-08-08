module JobServices
  class CheckIfStillLiveOnCareersSite
    def call(job_previews_currently_on_careers_site:, company:)
      jobs_marked_as_live_on_careers_site = company.jobs.where(live_on_careers_site: true)

      jobs_that_are_no_longer_live = jobs_marked_as_live_on_careers_site.select do |job_marked_as_live_on_careers_site|
        # if the job previews don't include the live job url then the live job
        # must have been removed
        !job_previews_currently_on_careers_site.map(&:url).include?(job_marked_as_live_on_careers_site.url)
      end

      jobs_that_are_no_longer_live.each do |job|
        job.update!(live_on_careers_site: false)
      end
    end
  end
end
