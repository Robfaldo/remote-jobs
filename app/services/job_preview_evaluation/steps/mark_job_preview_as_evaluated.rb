module JobPreviewEvaluation
  module Steps
    class MarkJobPreviewAsEvaluated < ::JobPreviewEvaluation::Step
      def call
        job_preview.status = "evaluated"
        job_preview.save!
      end

      def can_handle?
        true
      end
    end
  end
end
