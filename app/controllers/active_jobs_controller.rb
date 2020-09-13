class ActiveJobsController < ApplicationController
  include ActionView::Helpers::DateHelper
  def index
    @levels = Level.all
    @stacks = Stack.all

    if params[:search_by_location] # redirected from search controller
      jobs = Job.near(params["location_to_search"], params["distance"]).where(active: true).order(published_date: :desc)
    else
      jobs = Job.where(active: true).order(published_date: :desc)
    end

    jobs_to_json = jobs.to_json
    parsed_json = JSON.parse(jobs_to_json)
    parsed_json.each do |job|
      job["company_name"] = Job.find(job["id"]).company.name
      job["published_date_message"] = format_posted_message(job["published_date"])
      job["degree_required_message"] = job["degree_required"] ? "University degree required" : ""
    end

    all_active_jobs = parsed_json

    @jobs_to_show = all_active_jobs
  end

  private

  def jobs_to_show_params
    params.require(:jobs_to_show).map do |p|
      p.permit(
        :id,
        :published_date,
        :title,
        :job_link,
        :created_at,
        :updated_at,
        :level_id,
        :stack_id,
        :company_id,
        :active,
        :location,
        :longitude,
        :latitude,
        :distance,
        :bearing,
        :company_name
      )
    end
  end
end

def format_posted_message(published_date)
  return "Posted today" if Date.parse(published_date) == Date.today
  return "Posted over 30 days ago" if Date.parse(published_date) < Date.today - 30

  "Posted #{time_ago_in_words(published_date).remove('over')} ago"
end
