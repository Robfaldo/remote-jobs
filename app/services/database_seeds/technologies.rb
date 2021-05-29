module DatabaseSeeds
  class Technologies
    TECHNOLOGIES_YAML = File.read(Rails.root.join("config", "technologies.yml"))

    def self.call
      technologies = YAML.load(TECHNOLOGIES_YAML)

      technologies.each do |technology|
        technology_exists = Technology.where(name: technology["name"]).length > 0

        technology_exists ? update_technology(technology) : create_new_technology(technology)
      end
    end

    def self.update_technology(updated_technology)
      current_technology = Technology.where(name: updated_technology["name"]).first

      current_technology.aliases = updated_technology["aliases"]
      current_technology.is_language = updated_technology["is_language"]
      current_technology.is_framework = updated_technology["is_framework"]
      current_technology.used_for_frontend = updated_technology["used_for_frontend"]
      current_technology.used_for_backend = updated_technology["used_for_backend"]

      current_technology.save!
    end

    def self.create_new_technology(technology)
      new_technology = Technology.new(
        name: technology["name"],
        aliases: technology["aliases"],
        is_language: technology["is_language"],
        is_framework: technology["is_framework"],
        used_for_frontend: technology["used_for_frontend"],
        used_for_backend: technology["used_for_backend"]
      )

      new_technology.save!
    end

    private_class_method :update_technology, :create_new_technology
  end
end


