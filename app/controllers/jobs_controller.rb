class JobsController < ApplicationController
  def index
    levels = Level.names.select{ |name| params[name]["result"] == "1" if params[name] }

    @jobs = Job.joins(:level)
      .merge(Level.search(levels))
  end
end
