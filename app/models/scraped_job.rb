class ScrapedJob < ApplicationRecord
  validates :title, presence: true
  validates :job_link, presence: true
  validates :source, presence: true
  validates :searched_location, presence: true
end
