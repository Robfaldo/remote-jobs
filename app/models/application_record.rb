class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :created_today, lambda{ where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }
  scope :created_last_3_days, lambda{ where(created_at: (Date.today - 3)..Date.today.end_of_day) }
  scope :created_last_14_days, lambda{ where(created_at: (Date.today - 14)..Date.today.end_of_day) }
  scope :created_last_week, lambda{ where(created_at: (Date.today - 7)..Date.today.end_of_day) }
end
