class JobsController < ApplicationController
  def index
    @jobs = Job.default_jobs_viewer_jobs
  end
end
