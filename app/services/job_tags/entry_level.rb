module JobTags
  class EntryLevel < Tag
    def add_tag
      job.tag_list.add(tags_yaml["Groups"]["entry_level"])
      job.save!
    end

    def can_handle?
      level_matches = title_matches("level")

      level_matches.count > 0
    end

    def title_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end
  end
end
