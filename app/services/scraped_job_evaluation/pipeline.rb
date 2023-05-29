module ScrapedJobEvaluation
  class Pipeline
    STEPS = [
      FilterSteps::AlreadyAddedRecently,
      FilterSteps::BlackList,
      FilterSteps::EnsureJobTypeAllowed,
      FilterSteps::WrongJobType,
      Steps::ApproveForScraping
    ].freeze

    def initialize(scraped_jobs)
      @scraped_jobs = scraped_jobs
    end

    def process
      @scraped_jobs.each do |scraped_job|
        STEPS.each do |step|
          # stop executing steps if the scraped_job is filtered
          unless scraped_job.filtered
            current_step = step.new(scraped_job)

            current_step.call if current_step.can_handle?
          end
        end
      end
    end
  end
end
