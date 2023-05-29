ActiveAdmin.register JobPreview do
  permit_params :title, :job_link, :location, :company, :filter_reason, :status, :source, :searched_location
end
