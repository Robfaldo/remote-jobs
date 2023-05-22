class SourceLinksController < ApplicationController
  def index
    @sources = Job.sources
  end
end
