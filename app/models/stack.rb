class Stack < ApplicationRecord
  has_many :jobs

  validates :name, presence: true

end
