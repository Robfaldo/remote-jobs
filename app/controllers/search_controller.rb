class SearchController < ApplicationController
  def index
    area = params["location_area"]
    postcode = params["location_postcode"]

    postcode_provided = !postcode.empty?
    area_provided = !area.empty?

    location_to_search = if postcode_provided
                           format_postcode(postcode)
                         elsif area_provided
                           area
                         else
                           nil
                         end

    nearby_jobs = Job.near(location_to_search, params["location-dropdown"]).where(active: true)

    jobs_to_json = nearby_jobs.to_json
    parsed_json = JSON.parse(jobs_to_json)
    parsed_json.each do |job|
      job["company_name"] = Job.find(job["id"]).company.name
    end

    jobs_to_show = parsed_json

    redirect_to root_path(search_by_location: true, jobs_to_show: jobs_to_show)
  end

end

def format_postcode(postcode)
  postcode.delete(' ').split('').insert(-4, ' ').join
end
