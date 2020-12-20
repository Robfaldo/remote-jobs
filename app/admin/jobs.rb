ActiveAdmin.register Job do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :published_date, :title, :job_link, :location, :active
end
