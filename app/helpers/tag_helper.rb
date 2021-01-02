module TagHelper
  def filter_tag?(tag)
    filter_tags = tags_yaml["FilterRules"]

    filter_tags[tag]
  end

  def job_tag?(tag)
    filter_tags = tags_yaml["JobTags"]

    filter_tags[tag]
  end

  def tags_yaml
    YAML.load(File.read(Rails.root.join("config", "tags.yml")))
  end
end
