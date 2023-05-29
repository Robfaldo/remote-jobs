ActiveAdmin.register JobPreview do
  permit_params :title, :url, :location, :company, :filter_reason, :status, :source, :searched_location
end
