module Scraping
  module Sources
    module CareersPages
      class Gitlab < Greenhouse
        def sanitized_location(job_element)
          job_element.at('.location').text.strip.gsub("Remote, ","")
        end
      end
    end
  end
end

