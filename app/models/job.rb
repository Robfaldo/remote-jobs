class Job < ApplicationRecord
  geocoded_by :location
  after_validation :geocode

  validates :title, presence: true
  validates :company, presence: true
  validates :job_link, presence: true
  validates :location, presence: true
  validates :source, inclusion: { in: %w(indeed google stackoverflow glassdoor technojobs cv_library),
    message: "%{value} is not a valid source" }
  validates :description, presence: true
  validates :status, inclusion: { in: %w(scraped rejected approved),
    message: "%{value} is not a valid status" }

  scope :created_today, lambda{ where(['created_at > ?', 0.days.ago]) }
  scope :created_last_3_days, lambda{ where(['created_at > ?', 4.days.ago]) }

  def self.live_jobs
    Job.where(status: "scraped").order(:created_at).reverse
  end

  def self.rejected_jobs
    Job.where(status: "rejected").order(:created_at).reverse
  end

  def self.approved_jobs
    Job.where(status: "approved").order(:created_at).reverse
  end

  def self.by_date_and_source(date, source, status: nil)
    if status
      Job.where(created_at: date.beginning_of_day..date.end_of_day, source: source, status: status)
    else
      Job.where(created_at: date.beginning_of_day..date.end_of_day, source: source)
    end
  end

  def rejected?
    self.status == "rejected"
  end

  def approved?
    self.status == "approved"
  end

  def posted_date_range
    job_posted_date = self.created_at

    days_since_posting = (Date.today - job_posted_date.to_date).to_i

    case days_since_posting
    when 0
      "posted-today"
    when 1..3
      "posted-three-days"
    else
      "posted-over-three-days"
    end
  end

  def posted_days_ago
    days_ago = (Date.today - self.created_at.to_date).to_i

    return "30+ days ago" if days_ago > 29

    case days_ago
    when 0
      "Today"
    when 1
      "1 day ago"
    else
      "#{days_ago} days ago"
    end
  end
end
