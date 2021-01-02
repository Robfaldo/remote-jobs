class JobsController < ApplicationController
  include TagHelper

  def index
    @jobs = Job.default_jobs_viewer_jobs
  end

  def update
    render json: {reason: "Job ID not provided"}, status: :bad_request unless job_params[:id]

    job = Job.find(job_params[:id])

    render json: {reason: "Job could not be found for #{job.id}"}, status: :unprocessable_entity unless job

    if job_params[:status]
      job.status = job_params[:status]
      job.tag_list = []
      job.tag_list.add(tags_yaml["ReviewTags"]["marked_as_approved"])

      if job.save
        render json: job, status: :created
      else
        render json: {reason: "Job could not be found for #{job.id}"}, status: :unprocessable_entity
      end
    elsif job_params[:requires_experience]
      if job_params[:requires_experience] == "add-experience-requirement" || job_params[:requires_experience] == "remove-experience-requirement"
        job.toggle_experience_requirement

        if job.save
          render json: job, status: :created
        else
          render json: {reason: "Job could not be found for #{job.id}"}, status: :unprocessable_entity
        end
      end
    elsif job_params[:requires_stem_degree]
      job.toggle_stem_degree_requirement

      if job.save
        render json: job, status: :created
      else
        render json: {reason: "Job could not be found for #{job.id}"}, status: :unprocessable_entity
      end
    end
  end

  private

  def job_params
    params.require(:job).permit(:status, :id, :requires_experience, :requires_stem_degree)
  end
end
