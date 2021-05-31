class ScrapedJob < ApplicationRecord
  validates :title, presence: true
  validates :job_link, presence: true
  validates :source, presence: true
  validates :searched_location, presence: true

  def self.by_date_and_source(date, source, status: "approved")
    if status && status == :any
      where(created_at: date.beginning_of_day..date.end_of_day, source: source)
    elsif status
      where(created_at: date.beginning_of_day..date.end_of_day, source: source, status: status)
    else
      where(created_at: date.beginning_of_day..date.end_of_day, source: source)
    end
  end
  
  def self.rejected_jobs
    Job.where(status: "rejected").reverse_order
  end

  def self.approved_jobs
    Job.where(status: "approved").reverse_order
  end

  def self.scraped_jobs
    Job.where(status: "scraped").reverse_order
  end
end
