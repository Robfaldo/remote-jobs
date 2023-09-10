module JobPreviewEvaluation
  module FilterSteps
    class JobSuitableForPeopleInUk < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      FILTER_REASON = :job_not_suitable_for_people_in_the_uk

      def call
        reject_message = "Rejected because it's not in the UK"

        filter_job(job_preview, reject_message)
      end

      def can_handle?
        # if the location is unknown we will not filter the job, we will scrape it and determine
        # the location from the full job posting
        return false if location_set_as_unknown?
        return false if suitable_anywhere_in_world?

        job_is_from_careers_page? && job_is_not_based_in_uk?
      end

      private

      def location_set_as_unknown?
        job_preview.sanitized_location == "location_unknown"
      end

      def suitable_anywhere_in_world?
        job_preview.location.downcase == "global remote"
      end

      def job_is_not_based_in_uk?
        coordinates = if job_preview.sanitized_location
                        Geocoder.coordinates(job_preview.sanitized_location)
                      else
                        Geocoder.coordinates(job_preview.location)
                      end
        country = Geocoder.search(coordinates).first.country
        country != 'United Kingdom'
      end
    end
  end
end
