class Job < ApplicationRecord
  include TagHelper

  SOURCES = %w(indeed google stackoverflow glassdoor technojobs cv_library companies_direct totaljobs)

  acts_as_taggable
  acts_as_taggable_on :tags

  geocoded_by :location
  after_validation :geocode

  validates :title, presence: true
  validates :company, presence: true
  validates :job_link, presence: true
  validates :location, presence: true
  validates :source, inclusion: { in: SOURCES,
    message: "%{value} is not a valid source" }
  validates :description, presence: true
  validates :status, inclusion: { in: %w(scraped rejected approved),
    message: "%{value} is not a valid status" }

  scope :created_today, lambda{ where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }
  scope :created_last_3_days, lambda{ where(created_at: (Date.today - 3)..Date.today.end_of_day) }
  scope :created_last_14_days, lambda{ where(created_at: (Date.today - 14)..Date.today.end_of_day) }

  scope :remove_jobs_requiring_degree, -> do
    where(requires_stem_degree: false)
  end

  scope :remove_jobs_requiring_experience, -> do
    where(requires_experience: false)
  end

  scope :approved_jobs_by_date_range, ->(date_range) do
    case date_range
    when "anytime"
      includes(:tags).where(status: "approved").reverse_order
    when "today"
      includes(:tags).created_today.where(status: "approved").reverse_order
    when "3-days"
      includes(:tags).created_last_3_days.where(status: "approved").reverse_order
    end
  end

  scope :with_requirements, ->(requires_experience:, requires_degree:) do
    where(requires_experience: requires_experience, requires_stem_degree: requires_degree)
  end

  scope :approved, -> { where(status: "approved") }

  scope :default_jobs_viewer_jobs, -> do
    includes(:tags).where(reviewed: false).reverse_order
  end

  scope :to_review, -> { where(reviewed: false) }

  def self.live_jobs
    Job.where(status: "scraped").reverse_order
  end

  def self.rejected_jobs
    Job.where(status: "rejected").reverse_order
  end

  def self.approved_jobs
    Job.where(status: "approved").reverse_order
  end

  def self.by_date_and_source(date, source, status: "approved")
    if status
      Job.where(created_at: date.beginning_of_day..date.end_of_day, source: source, status: status)
    else
      Job.where(created_at: date.beginning_of_day..date.end_of_day, source: source)
    end
  end

  def self.sources
    SOURCES
  end

  def rejected?
    self.status == "rejected"
  end

  def approved?
    self.status == "approved"
  end

  def marked_as_approved?
    self.tags.map{|t| t.name}.include?('marked_as_approved')
  end

  def white_listed?
    self.tags.map{|t| t.name}.include?('white_listed')
  end

  def requires_experience?
    self.requires_experience
  end

  def requires_stem_degree?
    self.requires_stem_degree
  end

  def toggle_experience_requirement
    self.toggle(:requires_experience)
  end

  def toggle_stem_degree_requirement
    self.toggle(:requires_stem_degree)
  end

  def toggle_status
    if self.status == "approved"
      self.status = "rejected"

      unless self.tag_list.include?(tags_yaml["ReviewTags"]["marked_as_rejected"])
        self.tag_list.add(tags_yaml["ReviewTags"]["marked_as_rejected"])
      end
    elsif
      self.status == "rejected"
      self.status = "approved"

      unless self.tag_list.include?(tags_yaml["ReviewTags"]["marked_as_approved"])
        self.tag_list.add(tags_yaml["ReviewTags"]["marked_as_approved"])
      end
    end
  end

  def reviewed?
    self.reviewed
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

    return "30+ days" if days_ago > 29

    case days_ago
    when 0
      "Today"
    when 1
      "1 day"
    else
      "#{days_ago} days"
    end
  end

  def has_requirements?
    self.requires_stem_degree? || self.requires_experience?
  end

  def approved_with_requirements
    self.approved? && self.has_requirements?
  end
end
