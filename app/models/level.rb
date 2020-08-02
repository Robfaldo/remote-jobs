class Level < ApplicationRecord
  has_many :jobs

  validates :name, presence: true

  def self.search(ids)
    return all unless ids

    where(id: ids)
  end
end
