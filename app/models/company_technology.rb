class CompanyTechnology
  attr_reader :technology, :title_matches, :description_matches

  def initialize(technology:, title_matches:, description_matches:)
    @technology = technology
    @title_matches = title_matches
    @description_matches = description_matches
  end

  def name
    @technology.name
  end
end
