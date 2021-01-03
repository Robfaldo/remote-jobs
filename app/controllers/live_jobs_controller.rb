class LiveJobsController < ApplicationController
  DEFAULT_DATE_RANGE = "14-days"

  def index
    date_range = DEFAULT_DATE_RANGE
    include_jobs_with = []

    if filter_params
      include_jobs_with = JSON.parse(filter_params["include_jobs_that"])
      date_range = filter_params["date_range"]
      include_jobs_requiring_experience = include_jobs_with&.include?('requires-experience')
      include_jobs_requiring_degree = include_jobs_with&.include?('requires-stem-degree')
    end

    query = Job.approved_jobs_by_date_range(date_range)
    query = query.remove_jobs_requiring_degree unless include_jobs_requiring_degree
    query = query.remove_jobs_requiring_experience unless include_jobs_requiring_experience

    @jobs = query.page params[:page]
    @checked_date_range = date_range
    @checked_filter_tags = include_jobs_with
  end

  private

  def filter_params
    if params[:filters]
      params.require(:filters).permit(:date_range, :include_jobs_that)
    end
  end
end
