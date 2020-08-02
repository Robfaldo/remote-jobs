class Technology < ApplicationRecord
  has_and_belongs_to_many :jobs

  validates :name, presence: true

  def self.search(ids)
    return all unless ids

    where(id: ids)
  end
end
