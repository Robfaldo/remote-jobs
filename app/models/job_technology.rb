class JobTechnology < ApplicationRecord
  belongs_to :job
  belongs_to :technology

  validates :title_matches, presence: true # how many times it's mentioned in the title
  validates :description_matches, presence: true # how many times it's mentioned in the description
end
