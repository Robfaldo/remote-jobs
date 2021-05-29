module DatabaseSeeds
  class Technologies
    TECHNOLOGIES_YAML = File.read(Rails.root.join("config", "technologies.yml"))

    def self.call
      technologies = YAML.load(TECHNOLOGIES_YAML)

      technologies.each do |technology|
        technology_exists_already = Technology.where(name: technology["name"]).length > 0

        next if technology_exists_already # We don't want to replace existing technologies

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
    end
  end
end


