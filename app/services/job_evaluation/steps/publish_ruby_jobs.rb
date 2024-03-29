module JobEvaluation
  module Steps
    class PublishRubyJobs < ::JobEvaluation::Step
      def call
        url = Rails.env.production? ? "https://www.rubyjobs.io/api/v1/jobs" : "http://localhost:3000/api/v1/jobs"

        res = HTTParty.post(
          url,
          {
            body: JobDto.new(job).as_json.to_json,
            headers: {
              'Content-Type' => 'application/json',
              'Authorization' => "Bearer #{ENV["CUSTOMER_API_KEY"]}"
            }
          }
        )

        unless res.created?
          additional = {
            job_id: job.id,
            response_message: res.msg,
            response_code: res.code,
          }

          SendToErrorMonitors.send_error(error: "Ruby job publishing failed", additional: additional)
        end
      end

      def can_handle?
        !Rails.env.development? &&
          JobServices::Technologies.new(job).is_a_ruby_or_rails_job? &&
          (job.london_based? || fully_remote?) &&
          job.source == "direct_from_careers_page"
      end

      private

      def fully_remote?
        job.remote_status == "fully remote"
      end
    end
  end
end
