module Scraping
  module Sources
    module CareersPages
      class Base
        def initialize(company)
          @company = company
        end

        private

        attr_reader :company
      end
    end
  end
end

