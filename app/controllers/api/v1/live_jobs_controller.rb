module Api
  module V1
    class LiveJobsController < ActionController::API
      def index
        jobs = Job.live_jobs.map do |job|
          {
            id: job.id,
            title: job.title,
            location: job.location,
            added: job.created_at,
            company: job.company,
            url: job.url
          }
        end

        render json: jobs
      end
    end
  end
end
