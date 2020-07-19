class Job < ApplicationRecord
  has_and_belongs_to_many :technologies
  belongs_to :level
  belongs_to :stack
  belongs_to :company

  validates :published_date, presence: true
  validates :title, presence: true
  validates :job_link, presence: true
end
