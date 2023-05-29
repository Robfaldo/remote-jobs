module JobEvaluation
  class Step
    def initialize(job)
      @job = job
    end

    def call
      raise "#{self.class} does not implement call method"
    end

    def can_handle?
      raise "#{self.class} does not implement can_handle? method"
    end

    private

    attr_reader :job
  end
end
