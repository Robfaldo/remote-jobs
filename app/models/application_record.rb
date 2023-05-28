class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :created_over_n_days, ->(days) do
    where(['created_at < ?', days.days.ago])
  end
end
