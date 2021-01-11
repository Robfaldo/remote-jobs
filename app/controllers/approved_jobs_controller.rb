class ApprovedJobsController < ApplicationController
  before_action :authenticate_admin_user!

  include TagHelper

  MAX_JOBS_TO_SHOW = 50

  def index
    @jobs = Job.approved_jobs.order(:created_at).limit(MAX_JOBS_TO_SHOW)
  end
end
