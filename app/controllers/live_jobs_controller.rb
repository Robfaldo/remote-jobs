class LiveJobsController < ApplicationController
  def index
    @jobs = Job.live_jobs
  end
end
