module JobTags
  class EntryLevel < Tag
    def add_tag
      job.tag_list.add(tags_yaml["Groups"]["entry_level"])
      job.save!
    end

    def can_handle?
      level_matches = get_title_violations(rules, job)

      level_matches.count > 0
    end
  end
end
