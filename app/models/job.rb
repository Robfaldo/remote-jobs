class Job < ApplicationRecord
  include TagHelper

  has_many :job_technologies, dependent: :destroy
  has_many :technologies, through: :job_technologies
  belongs_to :company
  belongs_to :job_preview, optional: true

  SOURCES = %w(indeed google stackoverflow glassdoor technojobs cv_library totaljobs jobserve reed cwjobs linkedin direct_from_careers_page)
  STATUSES = %w(scraped filtered evaluated)

  acts_as_taggable
  acts_as_taggable_on :tags

  geocoded_by :location
  after_validation :geocode

  validates :title, presence: true
  validates :company, presence: true
  validates :scraped_company, presence: true
  validates :url, presence: true
  validates :location, presence: true
  validates :source, inclusion: { in: SOURCES, message: "%{value} is not a valid source" }
  validates :description, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }

  enum filter_reason: {
    already_added_recently: 0,
    blacklist: 1,
    wrong_job_type: 2
  }

  # Used by activeadmin via metaprogramming - don't delete for being unused
  scope :scraped, -> { where(status: "scraped") }
  scope :filtered, -> { where(status: "filtered") }
  scope :evaluated, -> { where(status: "evaluated") }
  scope :total, -> { all }
  ###################

  def self.live_jobs
    with_main_technology("ruby")
      .where(status: :evaluated)
      .order(created_at: :desc)
      .limit(25)
  end

  def filtered?
    self.status == "filtered"
  end

  def self.with_main_technology(technology_name)
    joins(job_technologies: :technology)
      .where(technologies: { name: technology_name }, job_technologies: { main_technology: true })
  end

  def london_based?
    if self.job_preview.sanitized_location
      coordinates = Geocoder.coordinates(self.job_preview.sanitized_location)
      london_coordinates = Geocoder.search("London").first.coordinates
      distance = Geocoder::Calculations.distance_between(coordinates, london_coordinates)
      distance < 1
    else
      self.distance_to("London") < 1
    end
  rescue NoMethodError => e
    false
  end

  def time_since_created
    ActionController::Base.helpers.time_ago_in_words(self.created_at)
  end
end
