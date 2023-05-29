class JobPreview < ApplicationRecord
  STATUSES =  %w(scraped filtered evaluated)

  validates :title, presence: true
  validates :url, presence: true
  validates :source, presence: true
  validates :searched_location, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }

  def filtered?
    self.status == "filtered"
  end

  # Used by activeadmin via metaprogramming - don't delete for being unused
  scope :scraped, -> { where(status: "scraped") }
  scope :filtered, -> { where(status: "filtered") }
  scope :evaluated, -> { where(status: "evaluated") }
  scope :total, -> { all }
  ###################
end
