module JobPreviewEvaluation
  class Step
    def initialize(job_preview)
      @job_preview = job_preview
    end

    def call
      raise "#{self.class} does not implement call method"
    end

    def can_handle?
      raise "#{self.class} does not implement can_handle? method"
    end

    private

    attr_reader :job_preview
  end
end
