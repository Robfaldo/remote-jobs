module JobTags
  class TagJobs
    TAGS = [
        JobTags::RequiresExperience,
        JobTags::RequiresStemDegree
    ]

    def initialize(jobs)
      @jobs = jobs
    end

    def call
      jobs.each do |job|
        TAGS.each do |tag|
          tagger = tag.new(job)

          tagger.add_tag if tagger.can_handle?
        end
      end
    end

    private

    attr_reader :jobs
  end
end