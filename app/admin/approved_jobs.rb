ActiveAdmin.register Job, as: "ApprovedJob" do
  permit_params :title, :url, :location, :longitude, :latitude, :description, :source, :source_id, :status, :company, :filter_reason, :company_id, :scraped_company, :remote_status, :tag_list

  menu label: "Approved Jobs"

  scope :rejected, default: true do |jobs|
    jobs.where(status: 'approved')
  end

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
    column :url
    column :tag_list
    column :filter_reason
    actions
  end
end
