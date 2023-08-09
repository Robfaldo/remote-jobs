module JobPreviewEvaluation
  module FilterSteps
    class JobBasedInUk < ::JobPreviewEvaluation::Step
      include EvaluationHelpers::FilterStepHelper

      FILTER_REASON = :job_not_based_in_the_uk

      def call
        reject_message = "Rejected because it's not in the UK"

        filter_job(job_preview, reject_message)
      end

      def can_handle?
        # if the location is unknown we won't filter the job preview, we will scrape it and determine
        # the location from the full job posting
        return false if job_is_from_careers_page? && location_set_as_unknown?

        job_is_from_careers_page? && job_is_not_based_in_uk?
      end

      private

      def location_set_as_unknown?
        job_preview.sanitized_location == "location_unknown"
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
