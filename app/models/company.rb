class Company < ApplicationRecord
  has_many :jobs, dependent: :delete_all

  validates :name, presence: true
end
