class Company < ApplicationRecord
  has_many :jobs, dependent: :delete_all
  has_many :job_technologies, through: :jobs

  validates :name, presence: true
end
