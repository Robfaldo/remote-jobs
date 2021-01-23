class LiveJobsController < ApplicationController
  before_action :require_login

  DEFAULT_DATE_RANGE = "anytime"
  MAX_JOBS_TO_SHOW = 100
  ITEMS_PER_PAGE = 20 # set in pagy.rb

  def index
    date_range = DEFAULT_DATE_RANGE

    if filter_params
      include_jobs_that = JSON.parse(filter_params["include_jobs_that"])
      date_range = filter_params["date_range"]
      include_jobs_requiring_experience = include_jobs_that&.include?('requires-experience')
      include_jobs_requiring_degree = include_jobs_that&.include?('requires-stem-degree')
    end

    query = Job.approved_jobs_by_date_range(date_range)
    query = query.remove_jobs_requiring_degree unless include_jobs_requiring_degree
    query = query.remove_jobs_requiring_experience unless include_jobs_requiring_experience

    @total_jobs = query.limit(MAX_JOBS_TO_SHOW)
    @pagy, @jobs = pagy(@total_jobs)
    @total_jobs_count = @total_jobs.count
    @show_pagination = @total_jobs_count > ITEMS_PER_PAGE

    respond_to do |format|
      format.js {render layout: false}
      format.html { render 'index'}
    end
  end

  private

  def filter_params
    if params[:filters]
      params.require(:filters).permit(:date_range, :include_jobs_that)
    end
  end

  def require_login
    unless current_user
      redirect_to page_path('homepage')
    end
  end
end
