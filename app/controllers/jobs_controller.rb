class JobsController < ApplicationController
  def index
    @levels = Level.names
    @stacks = Stack.names

    @jobs = Job.joins(:level, :stack)
      .merge(Level.search(params["levels"]))
      .merge(Stack.search(params["stacks"]))
  end
end
