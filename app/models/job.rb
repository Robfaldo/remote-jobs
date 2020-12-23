class Job < ApplicationRecord
  geocoded_by :location
  after_validation :geocode

  validates :title, presence: true
  validates :company, presence: true
  validates :job_link, presence: true
  validates :location, presence: true
  validates :source, inclusion: { in: %w(indeed google stackoverflow),
    message: "%{value} is not a valid source" }
  validates :description, presence: true
  validates :status, inclusion: { in: %w(scraped rejected approved),
    message: "%{value} is not a valid status" }

  def self.live_jobs
    Job.where(status: "scraped").order(:created_at).reverse
  end

  def self.rejected_jobs
    Job.where(status: "rejected").order(:created_at).reverse
  end

  def self.approved_jobs
    Job.where(status: "approved").order(:created_at).reverse
  end

  def self.by_date_and_source(date, source)
    Job.where(created_at: date.beginning_of_day..date.end_of_day, source: source)
  end

  def rejected?
    self.status == "rejected"
  end
end
