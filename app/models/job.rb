class Job < ApplicationRecord
  include TagHelper

  has_many :job_technologies, dependent: :destroy
  has_many :technologies, through: :job_technologies
  belongs_to :company

  SOURCES = %w(indeed google stackoverflow glassdoor technojobs cv_library totaljobs jobserve reed cwjobs linkedin)
  STATUSES =  %w(scraped filtered evaluated)

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

  # Used by activeadmin via metaprogramming - don't delete for being unused
  scope :approved, -> { where(status: "approved") }
  scope :rejected, -> { where(status: "rejected") }
  ###################

  def filtered?
    self.status == "filtered"
  end

  def main_technology_names
    self.job_technologies.select{|jt| jt.main_technology }.map(&:technology).map(&:name)
  end
end
