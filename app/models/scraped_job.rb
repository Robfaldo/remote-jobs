class ScrapedJob
  attr_accessor :title, :link, :location, :company

  def initialize(title:, link:, location: nil, company: nil)
    @title = title
    @link = link
    @company = company
    @location = location
  end
end
