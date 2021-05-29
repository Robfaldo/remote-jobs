class Technology < ApplicationRecord
  has_many :job_technologies
  has_many :jobs, through: :job_technologies

  validates :name, presence: true
  validates :aliases, presence: true
  validates :is_language, inclusion: [true, false]
  validates :is_framework, inclusion: [true, false]
  validates :used_for_frontend, inclusion: [true, false]
  validates :used_for_backend, inclusion: [true, false]
end
