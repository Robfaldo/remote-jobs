class Stack < ApplicationRecord
  has_many :jobs

  validates :name, presence: true

  def self.search(ids)
    return all unless ids

    where(id: ids)
  end

  def self.backend
    where(name: "backend").first
  end

  def self.frontend
    where(name: "frontend").first
  end

  def self.fullstack
    where(name: "fullstack").first
  end
end
