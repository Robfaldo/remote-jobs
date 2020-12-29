module JobFiltering
  class FilterJobs
    def initialize(jobs)
      @jobs = jobs
    end

    def call
      chain = AlreadyAddedRecently.new(BlackList.new(WhiteList.new(TitleRequirements.new(WrongJobType.new(CurrentStudentsOnly.new(ApproveJob.new()))))))

      jobs.each do |job|
        chain.call(job)
      end
    end

    private

    attr_reader :jobs
  end
end
