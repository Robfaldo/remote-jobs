module JobEvaluators
  class CheckIfDeveloperJob
    YAML_PATH = Rails.root.join("config", "job_evaluators", "check_if_developer_job.yml")
    INDICATORS_NEEDED_WITH_DESCRIPTION = 4

    def self.check_title_only(job)
      new(job).check_title_only
    end

    def self.check_title_and_description(job)
      new(job).check_title_and_description
    end

    def initialize(job)
      @job = job
    end

    def check_title_only
      meets_requirements_with_title_alone
    end

    def check_title_and_description
      return true if meets_requirements_with_title_alone # if it meets the requirements from title then no need to check description

      meets_requirements_with_title_and_description
    end

    private

    attr_reader :job

    def meets_requirements_with_title_alone
      software_term_matches = title_matches("software_terms")

      roles_satisfied = role_matches.count > 0
      software_indicator_satisfied = software_term_matches.count > 0 || technology_title_matches.count > 0

      roles_satisfied && software_indicator_satisfied
    end

    def meets_requirements_with_title_and_description
      software_term_matches = description_matches("software_terms")
      description_only_term_matches = description_matches("description_only_software_terms")

      roles_satisfied = role_matches.count > 0
      software_indicator_satisfied = (software_term_matches.count + technology_description_matches.count + description_only_term_matches.count) > INDICATORS_NEEDED_WITH_DESCRIPTION

      roles_satisfied && software_indicator_satisfied
    end

    def role_matches
      @role_matches ||= title_matches("role")
    end

    def technology_title_matches
      Technology.all_names_including_aliases.filter do |language|
        job.title.downcase.include?(language.downcase)
      end
    end

    def technology_description_matches
      Technology.all_names_including_aliases.filter do |language|
        job.description.downcase.include?(" " + language.downcase + " ")
      end
    end

    def title_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end

    def description_matches(yaml_title)
      rules[yaml_title].filter { |rule| job.description.downcase.include?(" " + rule.downcase + " ") }
    end

    def rules
      YAML.load(File.read(YAML_PATH))
    end
  end
end
