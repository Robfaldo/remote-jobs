module JobFiltering
  class FilterJobs
    FILTERS = [:current_students_only, :graduates_only, :requires_experience]

    def initialize(jobs)
      @jobs = jobs
    end

    def call
      FILTERS.each do |filter|
        yaml_path = Rails.root.join("config", "filter_rules", "#{filter.to_s}.yml")
        rules = YAML.load(File.read(yaml_path))
        white_list_rules = YAML.load(File.read(Rails.root.join("config", "filter_rules", "white_list.yml")))

        jobs.each do |job|
          title_rule_violations = get_title_violations(rules, job)
          description_rule_violations = get_description_violations(rules, job)
          white_list_matches = get_white_list_matches(white_list_rules, job)

          if white_list_matches.count > 0
            approve_job_with_whitelist_note(job, white_list_matches)
          elsif title_rule_violations.count > 0 || description_rule_violations.count > 0
            reject_job(title_rule_violations, description_rule_violations, job, filter)
          else
            approve_job(job)
          end

          job.save!
        end
      end
    end

    private

    def reject_job(title_rule_violations, description_rule_violations, job, filter)
      job.status = "rejected"

      if title_rule_violations.count > 0
        job.status_reason = "" unless job.status_reason
        job.status_reason << "Title violated the #{filter} filter - rule(s) violated were: #{title_rule_violations}."
      end

      if description_rule_violations.count > 0
        job.status_reason = "" unless job.status_reason
        job.status_reason << "Description violated the #{filter} filter - rule(s) violated were: #{description_rule_violations}."
      end
    end

    def approve_job(job)
      job.status = "approved" if job.status == "scraped" # we don't want to overwrite jobs already rejected by previous filters
    end

    def get_title_violations(rules, job)
      rules["title"].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end

    def get_description_violations(rules, job)
      rules["description"].filter { |rule| job.description.downcase.include?(rule.downcase) }
    end

    def get_white_list_matches(rules, job)
      matches = []
      matches.concat(rules["description"].filter { |rule| job.description.downcase.include?(rule.downcase) })
      matches.concat(rules["title"].filter { |rule| job.title.downcase.include?(rule.downcase) })

      matches
    end

    def approve_job_with_whitelist_note(job, white_list_matches)
      job.status = "approved"
      job.status_reason = "White listed: #{white_list_matches}"
    end

    attr_reader :jobs
  end
end