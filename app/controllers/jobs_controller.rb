class JobsController < ApplicationController
  def index
    levels = Level.names.select{ |name| params[name]["is_checked"] == "true" if params[name] }
    stacks = Stack.names.select{ |name| params[name]["is_checked"] == "true" if params[name] }

    @jobs = Job.joins(:level, :stack)
      .merge(Level.search(levels))
      .merge(Stack.search(stacks))
  end
end
