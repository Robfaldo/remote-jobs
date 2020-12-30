class LiveJobsController < ApplicationController
  def index
    @jobs = Job.default_live_jobs
  end
end
