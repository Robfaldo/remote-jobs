class Technology < ApplicationRecord
  has_and_belongs_to_many :jobs

  validates :name, presence: true

  def self.search(name)
    return all unless name

    where(name: name)
  end
end
