module Api
  module V1
    class LiveJobsController < ActionController::API
      def index
        jobs = Job.live_jobs.map do |job|
          JobDto.new(job)
        end

        render json: jobs
      end
    end
  end
end
