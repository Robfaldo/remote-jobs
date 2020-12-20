class Job < ApplicationRecord
  geocoded_by :location
  after_validation :geocode

  validates :title, presence: true
  validates :job_link, presence: true
  validates :location, presence: true
  validates :source, inclusion: { in: %w(indeed google stackoverflow),
    message: "%{value} is not a valid source" }
  validates :description, presence: true
  validates :status, inclusion: { in: %w(scraped rejected approved),
    message: "%{value} is not a valid status" }
end
