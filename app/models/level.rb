class Level < ApplicationRecord
  has_many :jobs

  validates :name, presence: true

  def self.names
    Level.all.distinct.pluck(:name)
  end

  def self.search(name)
    return Level.all unless name.count > 0

    where(name: name)
  end
end
