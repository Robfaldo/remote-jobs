module EvaluationHelpers
  module TagStepHelper
    def class_name_underscored
      self.class.name.split("::").last.underscore
    end

    def yaml_path
      Rails.root.join("config", "tag_rules", "#{class_name_underscored}.yml")
    end

    def rules
      YAML.load(File.read(yaml_path))
    end

    def get_title_violations(rules, job)
      rules["title"].filter { |rule| job.title.downcase.include?(rule.downcase) }
    end

    def get_description_violations(rules, job)
      rules["description"].filter { |rule| job.description.downcase.include?(rule.to_s.strip.downcase) }
    end

    def tags_yaml
      YAML.load(File.read(Rails.root.join("config", "tags.yml")))
    end
  end
end
