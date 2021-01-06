class ScrapingStatsController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    start_date = Job.order(:created_at).first.created_at.to_date
    end_date = Date.today
    @all_dates = (start_date..end_date).map{|date| date} # map turns it into array
  end
end
