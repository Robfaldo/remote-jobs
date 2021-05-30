module JobTags
  class AddTechnologies < Tag
    def add_tag
      Technology.all.each do |technology|
        regexes_for_technology_name_and_aliases = build_regexes(technology)

        title_matches = regexes_for_technology_name_and_aliases.map do |regex|
          job.title.downcase.scan(regex).count
        end.sum

        description_matches = regexes_for_technology_name_and_aliases.map do |regex|
          job.description.downcase.scan(regex).count
        end.sum

        if title_matches > 0 || description_matches > 0
          add_technology_to_job(technology, title_matches, description_matches)
        end
      end
    end

    def can_handle?
      true
    end

    private

    def build_regexes(technology)
      name_regex = /\b#{technology.name.downcase}\b/i
      alias_regexes = technology.parsed_aliases.map do |technology_alias|
        /\b#{technology_alias.downcase}\b/i
      end

      alias_regexes.push(name_regex)
    end

    def add_technology_to_job(technology, title_matches, description_matches)
      # If this technology already exists on this job then delete it, and add it again from scratch.
      # I do this because otherwise jobs can have the same technology multiple times if you
      # ran them through this service twice (e.g. after adding more technologies and updating the
      # technologies on all jobs)
      existing_job_technology = JobTechnology.where(job: job, technology: technology).first
      existing_job_technology.destroy if existing_job_technology

      job_technology = JobTechnology.new(
        job: job,
        technology: technology,
        title_matches: title_matches,
        description_matches: description_matches
      )

      job_technology.save!
    end
  end
end
