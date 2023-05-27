ActiveAdmin.register ScrapedJob do
  permit_params :title, :job_link, :location, :company, :status_reason, :status, :source, :searched_location
end
