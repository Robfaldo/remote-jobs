module JobPreviewEvaluation
  class Pipeline
    STEPS = [
      FilterSteps::AlreadyAddedRecently,
      FilterSteps::BlackList,
      FilterSteps::EnsureJobTypeAllowed,
      FilterSteps::WrongJobType,
      FilterSteps::JobBasedInUk,
      Steps::MarkJobPreviewAsEvaluated
    ].freeze

    def initialize(job_previews)
      @job_previews = job_previews
    end

    def process
      @job_previews.each do |job_preview|
        STEPS.each do |step|
          # stop executing steps if the job_preview is filtered
          unless job_preview.filtered?
            current_step = step.new(job_preview)

            current_step.call if current_step.can_handle?
          end
        end
      end
    end
  end
end
