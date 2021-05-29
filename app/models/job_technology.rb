class JobTechnology < ApplicationRecord
  belongs_to :job
  belongs_to :technology

  validates :title_matches, presence: true
  validates :description_matches, presence: true
end
