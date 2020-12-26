class JobToEvaluate
  attr_reader :title, :link, :location, :company

  def initialize(title:, link:, location: nil, company: nil)
    @title = title
    @link = link
    @location = location
    @company = company
  end
end