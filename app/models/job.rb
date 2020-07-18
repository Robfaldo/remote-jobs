class Job < ApplicationRecord
  has_and_belongs_to_many :technologies
  belongs_to :level
  belongs_to :stack
  belongs_to :company
end
