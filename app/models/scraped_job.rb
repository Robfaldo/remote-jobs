class ScrapedJob
  attr_reader :title, :company, :link, :location, :description, :source

  def initialize(title:, company:, link:, location:, description:, source:)
    @title = title
    @company = company
    @link = link
    @location = location
    @description = description
    @source = source
  end
end
