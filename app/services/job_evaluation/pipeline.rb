module JobEvaluation
  class Pipeline
    STEPS = [
      FilterSteps::AlreadyAddedRecently,
      FilterSteps::BlackList,
      FilterSteps::WrongJobType,
      TagSteps::RequiresExperience,
      TagSteps::RequiresStemDegree,
      TagSteps::EntryLevel,
      TagSteps::Developer,
      TagSteps::CurrentStudentsOnly,
      TagSteps::SuitableForBootcampGrads,
      TagSteps::Level,
      Steps::AddTechnologies,
      Steps::ChatGptMixed,
      Steps::MarkJobAsEvaluated
    ].freeze


    def initialize(jobs)
      @jobs = jobs
    end

    def process
      @jobs.each do |job|
        STEPS.each do |step|
          # stop executing steps if the job is filtered. For example if a job has already been added
          # or is blacklisted then we don't want to waste time/cost of tagging or making API calls etc
          unless job.filtered?
            current_step = step.new(job)

            current_step.call if current_step.can_handle?
          end
        end
      end
    end
  end
end
