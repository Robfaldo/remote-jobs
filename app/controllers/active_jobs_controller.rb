class ActiveJobsController < ApplicationController
  def index
    @jobs = Job.where(active: true)
  end
end
