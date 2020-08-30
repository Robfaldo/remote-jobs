class CreateJobController < ApplicationController
  include CreateJobHelper

  skip_before_action :verify_authenticity_token, :only => [:create]

  def create
    create_job(
      stack: Stack.where(id: params[:stack].to_i).first,
      title: params[:title],
      link: params[:link],
      company: Company.where(name: params[:company].downcase).first_or_create
    )
    # TODO: respond to API call
  end
end
