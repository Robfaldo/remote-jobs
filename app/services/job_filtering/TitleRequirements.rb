module JobFiltering
  class TitleRequirements < BaseHandler
    INDICATORS_NEEDED_WITH_DESCRIPTION = 4

    private

    attr_reader :job

    def handle(job)
      reject_message = "Rejected for title requiremenets. @meets_title_requirements: #{@meets_title_requirements}. "
      reject_message << "@meets_title_and_description_requirements: #{@meets_title_and_description_requirements}" if job.class == Job

      reject_job(job, reject_message)

      if job.class == Job
        job.tag_list.add(tags_yaml["FilterRules"]["title_requirements_not_met"])
      end

      job.save!
    end

    def can_handle?(job)
      @job = job

      if job.class == ScrapedJob
        return does_not_meet_requirements_to_scrape?
      else
        @meets_title_requirements = meets_requirements_for_only_title

        return false if @meets_title_requirements # If it meets title requirements then no need to check description

        @meets_title_and_description_requirements = meets_requirements_for_title_with_description

        return true unless @meets_title_and_description_requirements # if it doesn't meet title OR title_and_description requirements then we need to reject
      end
    end

    def meets_requirements_for_only_title
      role_matches = title_matches("role")

      software_term_matches = title_matches("software_terms")
      language_matches = title_matches("languages")
      framework_matches = title_matches("frameworks")

      roles_satisfied = role_matches.count > 0
      software_indicator_satisfied = software_term_matches.count > 0 || language_matches.count > 0 || framework_matches.count > 0

      roles_satisfied && software_indicator_satisfied
    end

    def meets_requirements_for_title_with_description
      # Must have these two in the title
      role_matches = title_matches("role")

      # Search the description for the software indicator
      software_term_matches = description_matches("software_terms")
      language_matches = description_matches("languages")
      framework_matches = description_matches("frameworks")
      description_only_term_matches = description_matches("description_only_software_terms")

      roles_satisfied = role_matches.count > 0
      software_indicator_satisfied = (software_term_matches.count + language_matches.count + framework_matches.count + description_only_term_matches.count) > INDICATORS_NEEDED_WITH_DESCRIPTION

      roles_satisfied && software_indicator_satisfied
    end

    def does_not_meet_requirements_to_scrape?
      role_matches = title_matches("role")
      # if they don't match the roles we look for then we don't want to scrape
      role_matches.count == 0
    end

    def title_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end

    def description_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.description.downcase.include?(" " + rule.downcase + " ") }
    end
  end
end
