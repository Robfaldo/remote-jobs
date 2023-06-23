ActiveAdmin.register JobPreview, as: "NonDupeRejectedJobPreviews" do
  permit_params :title, :url, :location, :company, :filter_reason, :status, :source, :searched_location, :filter_details

  menu label: "Job Preview Rejected"

  scope :non_dupe_rejected_job_previews, default: true do |job_previews|
    job_previews.where(status: "filtered").where.not(filter_reason: "already_added_recently")
  end

  index do
    selectable_column
    column :created_at
    column :status
    column :source
    column :title
    column :company
    column :searched_location
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
