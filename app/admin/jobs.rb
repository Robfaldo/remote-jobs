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
    column :scraped_company
    column :technologies do |job|
      job.technologies.map { |tech| tech.name }.join(', ')
    end
    column :location
    column :tag_list
    column :status_reason
    actions
  end
end
