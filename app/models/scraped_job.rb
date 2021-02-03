class ScrapedJob < ApplicationRecord
  validates :title, presence: true
  validates :job_link, presence: true
end
