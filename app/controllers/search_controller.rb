class SearchController < ApplicationController
  def index
    nearby_jobs = Job.near(params[:location], params["location-dropdown"]).where(active: true)

    jobs_to_json = nearby_jobs.to_json
    parsed_json = JSON.parse(jobs_to_json)
    parsed_json.each do |job|
      job["company_name"] = Job.find(job["id"]).company.name
    end

    jobs_to_show = parsed_json

    redirect_to root_path(search_by_location: true, jobs_to_show: jobs_to_show)
  end
end
