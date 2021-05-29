class Technology < ApplicationRecord
  has_many :job_technologies
  has_many :jobs, through: :job_technologies

  validates :name, presence: true
  validates :aliases, presence: true
  validates :is_language, presence: true
  validates :is_framework, presence: true
  validates :used_for_frontend, presence: true
  validates :used_for_backend, presence: true
end
