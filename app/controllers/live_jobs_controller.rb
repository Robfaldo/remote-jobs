class LiveJobsController < ApplicationController
  def index
    @jobs = Job.approved_jobs
    @jobs_posted_today = Job.created_today.filter{|job| job.approved? }&.count
    @jobs_posted_last_3 = Job.created_last_3_days.filter{|job| job.approved? }&.count
    @jobs_requiring_experience = Job.tagged_with("requires_experience").filter{|job| job.approved? }&.count
    @jobs_requiring_stem_degree = Job.tagged_with("requires_stem_degree").filter{|job| job.approved? }&.count
  end
end
