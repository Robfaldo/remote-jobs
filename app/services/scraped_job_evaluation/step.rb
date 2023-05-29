module ScrapedJobEvaluation
  class Step
    def initialize(scraped_job)
      @scraped_job = scraped_job
    end

    def call
      raise "#{self.class} does not implement call method"
    end

    def can_handle?
      raise "#{self.class} does not implement can_handle? method"
    end

    private

    attr_reader :scraped_job
  end
end
