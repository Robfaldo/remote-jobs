module JobFiltering
  class WhiteList < BaseHandler
    private

    def handle(job)
      approve_job(job, message: "White listed: #{@white_list_matches}.")
    end

    def can_handle?(job)
      @white_list_matches = []
      @white_list_matches.concat(get_title_violations(rules, job))
      @white_list_matches.concat(get_description_violations(rules, job))

      @white_list_matches.count > 0
    end
  end
end

