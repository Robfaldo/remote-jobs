class SourceLinksController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @sources = Job.sources
  end
end
