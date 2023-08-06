ActiveAdmin.register JobPreview do
  permit_params :title, :url, :location, :company, :filter_reason, :status, :source, :searched_location, :filter_details

  index do
    selectable_column
    column :created_at
    column :status
    column :source
    column :title
    column :company
    column :location
    column :url do |job|
      link_to job.url.truncate(100), job.url, target: '_blank'
    end
    column :filter_reason
    column :filter_details do |job|
      truncate(job.filter_details, length: 500)
    end
    actions
  end
end
