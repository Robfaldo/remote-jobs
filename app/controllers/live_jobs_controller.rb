class LiveJobsController < ApplicationController
  def index
    @jobs = Job.default_live_jobs
    @jobs_posted_today = Job.default_live_jobs_created_today&.count
    @jobs_posted_last_3 = Job.default_live_jobs_created_last_3&.count

    @jobs_requiring_experience = Job.tagged_with("requires_experience").filter{|job| job.approved? }&.count
    @jobs_requiring_stem_degree = Job.tagged_with("requires_stem_degree").filter{|job| job.approved? }&.count
  end
end
