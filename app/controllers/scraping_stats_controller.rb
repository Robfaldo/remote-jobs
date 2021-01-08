class ScrapingStatsController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    start_date = Job.order(:created_at).first.created_at.to_date
    end_date = Date.today
    @all_dates = (start_date..end_date).map{|date| date} # map turns it into array
    @total_approved_jobs = Job.approved_jobs.count
    @total_approved_jobs_requiring_only_experience = Job.approved_jobs.with_requirements(
        requires_experience: true,
        requires_degree: false).count
    @total_approved_jobs_requiring_only_degree = Job.approved_jobs.with_requirements(
        requires_experience: false,
        requires_degree: true).count
    @total_approved_jobs_requiring_degree_and_experience = Job.approved_jobs.with_requirements(
        requires_experience: true,
        requires_degree: true).count
    @total_approved_jobs_with_no_requirements = Job.approved_jobs.with_requirements(
        requires_experience: false,
        requires_degree: false).count
  end
end
