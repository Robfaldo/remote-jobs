module SourceLinksHelper
  def links_for_all_locations(source)
    source_links(source)
  end

  private

  def source_links(source)
    YAML.load(File.read(yaml_path(source)))
  end

  def yaml_path(source)
    Rails.root.join("config", "search_links", "#{source}_scraper.yml")
  end
end
