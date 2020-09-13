class Job < ApplicationRecord
  geocoded_by :location
  after_validation :geocode

  has_and_belongs_to_many :technologies
  belongs_to :level
  belongs_to :stack
  belongs_to :company

  validates :published_date, presence: true
  validates :title, presence: true
  validates :job_link, presence: true
  validates :location, presence: true
  validates :degree_required, inclusion: { in: [ true, false ] } # can't use presence: true (because false boolean would fail this check)
end
