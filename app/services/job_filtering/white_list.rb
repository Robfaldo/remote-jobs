module JobFiltering
  class WhiteList < BaseHandler
    private

    def handle(job)
      approve_job(job, message: "White listed: #{@white_list_matches}.")
      job.tag_list.add(tags_yaml["FilterRules"]["white_listed"])
      job.requires_experience = false
      job.requires_stem_degree = true
      job.save!
    end

    def can_handle?(job)
      return false if job.class == ScrapedJob

      @white_list_matches = []
      @white_list_matches.concat(get_title_violations(rules, job))
      @white_list_matches.concat(get_description_violations(rules, job))

      @white_list_matches.count > 0
    end
  end
end

