module JobTags
  class SuitableForBootcampGrads < Tag
    def add_tag
      job.tag_list.add(tags_yaml["Groups"]["suitable_for_bootcamp_grads"])
      job.save!
    end

    def can_handle?
      white_list_matches = []
      white_list_matches.concat(get_title_violations(rules, job))
      white_list_matches.concat(get_description_violations(rules, job))

      white_list_matches.count > 0
    end
  end
end
