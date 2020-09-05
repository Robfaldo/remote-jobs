class CreateJobController < ApplicationController
  include CreateJobHelper

  skip_before_action :verify_authenticity_token, :only => [:create]

  def create
    job = create_job(
      stack: Stack.where(id: params[:stack].to_i).first,
      title: params[:title],
      link: params[:link],
      company: Company.where(name: params[:company].downcase).first_or_create,
      location: params[:location]
    )

    if job
      render json: 'created', status: 201
    else
      # TODO: much better responses :)
      render json: 'error, really need to add more logging and better status codes though because you will have no idea what is wrong, sorry.', status: 500
    end
  end
end
