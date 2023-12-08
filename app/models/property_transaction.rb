class PropertyTransaction < ApplicationRecord
  validates :searched_url, :searched_postcode, :url, :address, :date_of_sale, :price, presence: true
  validates :url, uniqueness: true
end


