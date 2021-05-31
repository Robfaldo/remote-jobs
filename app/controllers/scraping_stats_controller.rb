class ScrapingStatsController < ApplicationController
  before_action :authenticate_admin!

  def index
    start_date = Job.order(:created_at).first.created_at.to_date
    end_date = Date.today
    @all_dates = (start_date..end_date).map{|date| date}.sort.reverse[0...10] # last 10 days
    @sites = Job::SOURCES
  end
end
