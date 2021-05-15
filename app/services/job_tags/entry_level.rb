module JobTags
  class EntryLevel < Tag
    INDICATORS_NEEDED_WITH_DESCRIPTION = 4

    def add_tag
      job.tag_list.add(tags_yaml["Groups"]["entry_level"])
      job.save!
    end

    def can_handle?
      @meets_title_requirements = meets_requirements_for_only_title

      return true if @meets_title_requirements # If it meets title requirements then no need to check description

      @meets_title_and_description_requirements = meets_requirements_for_title_with_description

      return true if @meets_title_and_description_requirements # if it meets title OR title_and_description requirements then we want to tag
    end

    def meets_requirements_for_only_title
      level_matches = title_matches("level")
      role_matches = title_matches("role")
      software_term_matches = title_matches("software_terms")
      language_matches = title_matches("languages")
      framework_matches = title_matches("frameworks")

      level_satisfied = level_matches.count > 0
      roles_satisfied = role_matches.count > 0
      software_indicator_satisfied = software_term_matches.count > 0 || language_matches.count > 0 || framework_matches.count > 0

      level_satisfied && roles_satisfied && software_indicator_satisfied
    end

    def meets_requirements_for_title_with_description
      # Must have these two in the title
      level_matches = title_matches("level")
      role_matches = title_matches("role")

      # Search the description for the software indicator
      software_term_matches = description_matches("software_terms")
      language_matches = description_matches("languages")
      framework_matches = description_matches("frameworks")
      description_only_term_matches = description_matches("description_only_software_terms")

      level_satisfied = level_matches.count > 0
      roles_satisfied = role_matches.count > 0
      software_indicator_satisfied = (software_term_matches.count + language_matches.count + framework_matches.count + description_only_term_matches.count) > INDICATORS_NEEDED_WITH_DESCRIPTION

      level_satisfied && roles_satisfied && software_indicator_satisfied
    end

    def title_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end

    def description_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.description.downcase.include?(" " + rule.downcase + " ") }
    end
  end
end
