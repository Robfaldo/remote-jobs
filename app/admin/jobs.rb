ActiveAdmin.register Job do
  permit_params :title, :url, :location, :longitude, :latitude, :description, :source, :source_id, :status, :company, :filter_reason, :filter_details, :company_id, :scraped_company, :remote_status, :tag_list

  index do
    selectable_column
    column :created_at
    column :status
    column :source
    column :title
    # column :description do |job|
    #   truncate(job.description, length: 50)
    # end
    column :company
    column :technologies do |job|
      job.technologies.map { |tech| tech.name }.join(', ')
    end
    column :main_technologies do |job|
      job.main_technology_names
    end
    column :location
    column :remote_status
    column :url do |job|
      link_to job.url.truncate(100), job.url, target: '_blank'
    end
    column :tag_list
    column :filter_reason
    column :filter_details
    actions
  end
end
