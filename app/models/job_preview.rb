class JobPreview < ApplicationRecord
  STATUSES =  %w(scraped filtered evaluated)

  validates :title, presence: true
  validates :url, presence: true
  validates :source, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }

  enum filter_reason: {
    already_added_recently: 0,
    blacklist: 1,
    job_type_not_allowed: 2,
    wrong_job_type: 3,
    job_not_based_in_the_uk: 4
  }

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
