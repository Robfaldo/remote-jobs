module JobFiltering
  class BlackList < BaseHandler
    private

    def handle(job)
      reject_job(job,"Black listed: #{@black_list_violations}.")
    end

    def can_handle?(job)
      @black_list_violations = rules["job_link"].filter { |rule| job.job_link.downcase.include?(rule.downcase) }

      @black_list_violations.count > 0
    end
  end
end