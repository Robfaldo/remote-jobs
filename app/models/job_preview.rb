class JobPreview < ApplicationRecord
  STATUSES =  %w(scraped filtered evaluated)

  validates :title, presence: true
  validates :job_link, presence: true
  validates :source, presence: true
  validates :searched_location, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }

  def filtered?
    self.status == "filtered"
  end
end
