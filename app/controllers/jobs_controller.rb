class JobsController < ApplicationController
  def index
    @jobs = Job.created_last_14_days
  end
end
