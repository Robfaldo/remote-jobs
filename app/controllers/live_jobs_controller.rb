class LiveJobsController < ApplicationController
  def index
    @jobs = Job.approved_jobs
    @jobs_posted_today = Job.created_today.filter{|job| job.approved? }
    @jobs_posted_last_3 = Job.created_last_3_days.filter{|job| job.approved? }
  end
end
