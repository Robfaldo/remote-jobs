module Scraping
  module Sources
    module CareersPages
      class Cleo < Greenhouse
        def sanitized_location(job_element)
          job_element.at('.location').text.strip.gsub(" or remote (U.K)","")
        end
      end
    end
  end
end

