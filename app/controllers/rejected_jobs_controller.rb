class RejectedJobsController < ApplicationController
  def index
    @jobs = Job.rejected_jobs
  end
end
