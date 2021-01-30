class JobToEvaluate
  attr_accessor :title, :link, :location, :company

  def initialize(title:, link:, location: nil, company: nil)
    @title = title
    @link = link
    @location = location
    @company = company
  end

  def meets_minimum_requirements?
    level_matches = title_matches("level")
    role_matches = title_matches("role")

    level_matches.count > 0 && role_matches.count > 0
  end

  private

  def title_matches(yaml_title)
    rules[yaml_title].filter { |rule| self.title.downcase.include?(rule.downcase) }
  end

  def yaml_path
    Rails.root.join("config", "filter_rules", "title_requirements.yml")
  end

  def rules
    YAML.load(File.read(yaml_path))
  end
end