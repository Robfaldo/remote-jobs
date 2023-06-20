module JobEvaluation
  class Step
    def initialize(job)
      @job = job
      @job_technologies_service = JobServices::Technologies.new(job)
    end

    def call
      raise "#{self.class} does not implement call method"
    end

    def can_handle?
      raise "#{self.class} does not implement can_handle? method"
    end

    private

    attr_reader :job, :job_technologies_service
  end
end
