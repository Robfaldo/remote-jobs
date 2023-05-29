module JobEvaluation
  module Steps
    class MarkJobAsEvaluated < ::JobEvaluation::Step
      def call
        job.status = "evaluated"
        job.save!
      end

      def can_handle?
        true
      end
    end
  end
end
