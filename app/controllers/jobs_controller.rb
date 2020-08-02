class JobsController < ApplicationController
  def index
    @technologies = Technology.all
    @levels = Level.all
    @stacks = Stack.all

    @jobs = Job.joins(:level, :stack, :technologies)
      .merge(Level.search(params["levels"]))
      .merge(Stack.search(params["stacks"]))
      .merge(Technology.search(params["technologies"]))
      .distinct
  end
end
