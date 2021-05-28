# Purpose of this tag is to determine if the job is a developer (rather than tester, devops, data etc...)

module JobTags
  class Developer < Tag
    INDICATORS_NEEDED_WITH_DESCRIPTION = 4

    def add_tag
      job.tag_list.add(tags_yaml["Groups"]["developer"])
      job.save!
    end

    def can_handle?
      @meets_title_requirements = meets_requirements_for_only_title

      return true if @meets_title_requirements # If it meets title requirements then no need to check description

      @meets_title_and_description_requirements = meets_requirements_for_title_with_description

      return true if @meets_title_and_description_requirements # if it meets title_and_description requirements then we want to tag
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

    def title_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end

    def description_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.description.downcase.include?(" " + rule.downcase + " ") }
    end
  end
end
