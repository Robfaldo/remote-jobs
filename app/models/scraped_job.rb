class ScrapedJob < ApplicationRecord
  attr_accessor :title, :link, :location, :company

  validates :title, presence: true
  validates :job_link, presence: true
end
