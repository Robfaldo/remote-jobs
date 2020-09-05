ActiveAdmin.register Job do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :published_date, :title, :job_link, :level_id, :stack_id, :company_id, :location, :active, technology_ids: []

  # I had to customise what is shown for Job because we needed to add technologies, which is a many to many relationship so
  # wasn't showing up as an option to add by default. See this blog post for what I used as template: https://medium.com/alturasoluciones/has-many-relations-in-active-admin-2668b04c7069

  index do
    selectable_column
    id_column
    column :published_date
    column :title
    column :job_link
    column :level
    column :stack
    column :company
    column :location
    column :active
    column :technologies do |job|
      table_for job.technologies.order('name ASC') do
        column do |technology|
          technology.name
        end
      end
    end
  end

  show do
    attributes_table do
      row :published_date
      row :title
      row :job_link
      row :level
      row :stack
      row :company
      row :location
      row :active
      table_for job.technologies.order('name ASC') do
        column "Technologies" do |technology|
          link_to technology.name, [ :admin, technology ]
        end
      end
    end
  end

  form do |f|
    f.inputs "Add/Edit Article" do
      f.input :published_date
      f.input :title
      f.input :job_link
      f.input :level
      f.input :stack
      f.input :company
      f.input :location
      f.input :active
      f.input :technologies, :as => :check_boxes
    end
    actions
  end
end
