ActiveAdmin.register Job, as: "RejectedJob" do
  permit_params :title, :job_link, :location, :longitude, :latitude, :description, :job_board, :source, :source_id, :status, :company, :status_reason, :salary, :reviewed, :requires_stem_degree, :requires_experience, :edited, :company_id, :scraped_company, :remote_status, :tag_list

  menu label: "Rejected Jobs"

  scope :rejected, default: true do |jobs|
    developer_jobs_ids = Job.tagged_with('developer').pluck(:id)
    Job.where(status: 'rejected').where.not(id: developer_jobs_ids)
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
    column :job_link
    column :tag_list
    column :status_reason
    actions
  end
end
