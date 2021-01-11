class SourceLinksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @sources = Job.sources
  end
end
