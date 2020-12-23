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

        jobs.each do |job|
          title_rule_violations = get_title_violations(rules, job)
          description_rule_violations = get_description_violations(rules, job)

          if title_rule_violations.count > 0 || description_rule_violations.count > 0
            job.status = "rejected"

            if title_rule_violations.count > 0
              job.status_reason = "" unless job.status_reason
              job.status_reason << "Title violated the #{filter} filter - rule(s) violated were: #{title_rule_violations}."
            end

            if description_rule_violations.count > 0
              job.status_reason = "" unless job.status_reason
              job.status_reason << "Description violated the #{filter} filter - rule(s) violated were: #{description_rule_violations}."
            end
          else
            job.status = "approved" if job.status == "scraped" # we don't want to overwrite jobs already rejected by previous filters
          end

          job.save!
        end
      end
    end

    private

    def get_title_violations(rules, job)
      rules["title"].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end

    def get_description_violations(rules, job)
      rules["description"].filter { |rule| job.description.downcase.include?(rule.downcase) }
    end

    attr_reader :jobs
  end
end