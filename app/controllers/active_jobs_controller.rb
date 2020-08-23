class ActiveJobsController < ApplicationController
  def index
    @jobs = Job.where(active: true)
    @levels = Level.all
    @stacks = Stack.all

    jobs_to_json = @jobs.to_json
    parsed_json = JSON.parse(jobs_to_json)
    parsed_json.each do |job|
      job["company_name"] = Job.find(job["id"]).company.name
    end

    @active_jobs_with_company_names = parsed_json
  end
end
