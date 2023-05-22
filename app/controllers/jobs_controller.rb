class JobsController < ApplicationController
  include TagHelper

  MAX_JOBS_TO_SHOW = 50

  def index
    jobs = Job.default_jobs_viewer_jobs.limit(MAX_JOBS_TO_SHOW)
    ## this is so I get them in the right order. There's a better way to do this but i can't work it out >.<
    approved_jobs_without_reqs = jobs.to_ary.select{|j| j.approved? == true && !j.has_requirements?}
    approved_jobs_with_reqs = jobs.to_ary.select{|j| j.approved? == true && j.has_requirements?}
    rejected_jobs = jobs.to_ary.select{|j| j.approved? == false}
    @jobs = approved_jobs_without_reqs.concat(approved_jobs_with_reqs.concat(rejected_jobs))
    @jobs_to_review = Job.to_review.count
  end

  def update
    render json: {reason: "Job ID not provided"}, status: :bad_request unless job_params[:id]

    job = Job.find(job_params[:id])

    render json: {reason: "Job could not be found for #{job.id}"}, status: :unprocessable_entity unless job

    if job_params[:status]
      job.toggle_status
      job.edited = true
    elsif job_params[:requires_experience]
      job.toggle_experience_requirement
      job.edited = true
    elsif job_params[:requires_stem_degree]
      job.toggle_stem_degree_requirement
      job.edited = true
    elsif job_params[:mark_as_reviewed]
      job.reviewed = true
    end

    if job.save
      render json: job, status: :created
    else
      render json: {reason: "Job could not be found for #{job.id}"}, status: :unprocessable_entity
    end
  end

  private

  def job_params
    params.require(:job).permit(:status, :id, :requires_experience, :requires_stem_degree, :mark_as_reviewed)
  end
end
