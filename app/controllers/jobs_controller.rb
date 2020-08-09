class JobsController < ApplicationController
  def index
    @technologies = Technology.all
    @levels = Level.all
    @stacks = Stack.all

    @selected_technologies = params["technologies"]&.map(&:to_i) || []
    @selected_levels = params["levels"]&.map(&:to_i) || []
    @selected_stacks = params["stacks"]&.map(&:to_i) || []

    job_filtering_service = JobFilteringService.new

    @jobs = job_filtering_service.call(
      levels: @selected_levels,
      stacks: @selected_stacks,
      technologies: @selected_technologies
    )
  end
end
