class Company < ApplicationRecord
  has_many :jobs, dependent: :destroy_all

  validates :name, presence: true
end
