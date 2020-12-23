class LiveJobsController < ApplicationController
  def index
    @jobs = Job.approved_jobs
  end
end
