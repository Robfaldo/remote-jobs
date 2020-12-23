module JobFiltering
  class FilterJobs
    def initialize(jobs)
      @jobs = jobs
    end

    def call
      chain = BlackList.new(WhiteList.new(RequiresExperience.new(WrongJobType.new(CurrentStudentsOnly.new(GraduatesOnly.new(ApproveJob.new()))))))

      jobs.each do |job|
        chain.call(job)
      end
    end

    private

    attr_reader :jobs
  end
end
