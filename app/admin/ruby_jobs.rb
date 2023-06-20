ActiveAdmin.register Job, as: "RubyJobs" do
  permit_params :title, :url, :location, :longitude, :latitude, :description, :source, :source_id, :status, :company, :filter_reason, :filter_details, :company_id, :scraped_company, :remote_status, :tag_list

  menu label: "Ruby Jobs"

  scope :ruby_jobs, default: true do |jobs|
    jobs.with_main_technology('ruby')
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
      JobServices::Technologies.new(job).main_technology_names
    end
    column :location
    column :remote_status
    column :url do |job|
      link_to job.url.truncate(100), job.url, target: '_blank'
    end
    column :tag_list
    column :filter_reason
    column :filter_details do |job|
      truncate(job.filter_details, length: 500)
    end
    actions
  end
end
