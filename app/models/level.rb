class Level < ApplicationRecord
  has_many :jobs

  validates :name, presence: true

  def self.search(name)
    return all unless name

    where(name: name)
  end
end
