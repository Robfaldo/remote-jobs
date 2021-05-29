# Purpose of this tag is to determine if the job is a developer (rather than tester, devops, data etc...)

module JobTags
  class Developer < Tag
    def add_tag
      job.tag_list.add(tags_yaml["Groups"]["developer"])
      job.save!
    end

    def can_handle?
      JobEvaluators::CheckIfDeveloperJob.check_title_and_description(job)
    end
  end
end
