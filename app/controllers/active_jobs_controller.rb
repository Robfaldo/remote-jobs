class ActiveJobsController < ApplicationController
  def index
    @jobs = Job.where(active: true)
    @levels = Level.all
    @stacks = Stack.all
  end
end
