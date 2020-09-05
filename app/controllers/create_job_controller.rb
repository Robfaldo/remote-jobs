class CreateJobController < ApplicationController
  include CreateJobHelper

  skip_before_action :verify_authenticity_token, :only => [:create]

  def create
    begin
      job = create_job(
          stack: Stack.where(id: params[:stack].to_i).first,
          title: params[:title],
          link: params[:link],
          company: Company.where(name: params[:company].downcase).first_or_create,
          location: params[:location]
      )
    rescue => e
      render json: e.message, status: 400 # TODO: Should this be 422? Think i should have multiple conditions based on the error raised.
    end

    render json: 'created', status: 201 if job
  end
end
