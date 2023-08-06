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
        job_is_from_careers_page? && job_is_not_based_in_uk?
      end

      private

      def job_is_not_based_in_uk?
        coordinates = Geocoder.coordinates(job_preview.location)
        country = Geocoder.search(coordinates).first.country
        country != 'United Kingdom'
      end
    end
  end
end
