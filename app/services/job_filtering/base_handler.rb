module JobFiltering
  class BaseHandler
    attr_reader :successor

    def initialize(successor = nil)
      @successor = successor
    end

    def call(job)
      if can_handle?(job)
        handle(job)
      else
        successor.call(job) if successor
      end
    end

    def handle(job)
      raise NotImplementedError, "#{self.class.name}: Handler should respond to handle methods"
    end

    def can_handle(job)
      raise NotImplementedError, "#{self.class.name}: Handler should respond to can_handle? methods"
    end

    ###########################
    ###########################
    ###########################
    ##### Shared methods ######

    def yaml_path
      Rails.root.join("config", "filter_rules", "#{class_name_underscored}.yml")
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

    def reject_job_for_title_or_description_violations(title_rule_violations, description_rule_violations, job, filter)
      job.status = "rejected"

      if title_rule_violations.count > 0
        job.status_reason = "" unless job.status_reason
        job.status_reason << "Title violated the #{filter} filter - rule(s) violated were: #{title_rule_violations}."
      end

      if description_rule_violations.count > 0
        job.status_reason = "" unless job.status_reason
        job.status_reason << "Description violated the #{filter} filter - rule(s) violated were: #{description_rule_violations}."
      end

      job.save!
    end

    def class_name_underscored
      self.class.name.split("::")[1].underscore
    end

    def reject_job(job, message)
      job.status = "rejected"

      job.status_reason = message

      job.save!
    end

    def approve_job(job, message: nil)
      job.status = "approved"

      job.status_reason = message if message

      job.save!
    end

    def tags_yaml
      YAML.load(File.read(Rails.root.join("config", "tags.yml")))
    end
  end
end
