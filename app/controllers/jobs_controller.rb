class JobsController < ApplicationController
  def index
    @technologies = Technology.all
    @levels = Level.all
    @stacks = Stack.all

    job_filtering_service = JobFilteringService.new

    @jobs = job_filtering_service.call(
      levels: params["levels"]&.map(&:to_i) || [],
      stacks: params["stacks"]&.map(&:to_i) || [],
      technologies: params["technologies"]&.map(&:to_i) || []
    )
  end
end
