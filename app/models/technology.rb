class Technology < ApplicationRecord
  validates :name, presence: true
  validates :aliases, presence: true
  validates :is_language, presence: true
  validates :is_framework, presence: true
  validates :used_for_frontend, presence: true
  validates :used_for_backend, presence: true
end
