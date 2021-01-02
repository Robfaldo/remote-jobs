class LiveJobsController < ApplicationController
  def index
    @jobs = Job.includes(:tags).default_live_jobs
  end
end
