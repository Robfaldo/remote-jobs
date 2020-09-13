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

    redirect_to root_path(search_by_location: true, location_to_search: location_to_search, distance: params["location-dropdown"])
  end

end

def format_postcode(postcode)
  postcode.delete(' ').split('').insert(-4, ' ').join
end
