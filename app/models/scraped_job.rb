class ScrapedJob
  attr_reader :title, :company, :link, :location, :description, :source, :source_id

  def initialize(title:, company:, link:, location:, description:, source:, source_id: nil)
    @title = title
    @company = company
    @link = link
    @location = location
    @description = description
    @source = source
    @source_id = source_id
  end
end
