class ScrapedJob
  attr_reader :title, :company, :link, :location, :description

  def initialize(title:, company:, link:, location:, description:)
    @title = title
    @company = company
    @link = link
    @location = location
    @description = description
  end
end
