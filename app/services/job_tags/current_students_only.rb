module JobTags
  class CurrentStudentsOnly < Tag
    def add_tag
      job.tag_list.add(tags_yaml["Groups"]["current_students_only"])
      job.save!
    end

    def can_handle?
      title_rule_violations = title_matches("title")

      title_rule_violations.count > 0
    end

    def title_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end
  end
end
