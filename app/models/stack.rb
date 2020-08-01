class Stack < ApplicationRecord
  has_many :jobs

  validates :name, presence: true

  def self.names
    Stack.all.distinct.pluck(:name)
  end

  def self.search(name)
    return all unless name

    where(name: name)
  end
end
