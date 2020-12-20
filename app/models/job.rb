class Job < ApplicationRecord
  geocoded_by :location
  after_validation :geocode

  validates :published_date, presence: true
  validates :title, presence: true
  validates :job_link, presence: true
  validates :location, presence: true
end
