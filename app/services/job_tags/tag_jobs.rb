module JobTags
  class TagJobs
    TAGS = [
        JobTags::RequiresExperience,
        JobTags::RequiresStemDegree,
        JobTags::EntryLevel,
        JobTags::Developer,
        JobTags::CurrentStudentsOnly,
        JobTags::SuitableForBootcampGrads,
        JobTags::AddTechnologies,
        JobTags::CoreTechnologies::RubyJob
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
