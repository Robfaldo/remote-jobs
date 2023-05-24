ActiveAdmin.register Job do
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
