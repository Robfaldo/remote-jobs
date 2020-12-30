module JobTags
  class Tag
    def initialize(job)
      @job = job
    end

    private

    attr_reader :job

    def class_name_underscored
      self.class.name.split("::")[1].underscore
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
      rules["description"].filter { |rule| job.description.downcase.include?(rule.downcase) }
    end
  end
end
