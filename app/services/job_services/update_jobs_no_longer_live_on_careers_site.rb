module JobServices
  class UpdateJobsNoLongerLiveOnCareersSite
    def call(job_previews_currently_on_careers_site:, company:)
      jobs_marked_as_live_on_careers_site = company.jobs.where(live_on_careers_site: true)

      jobs_that_are_no_longer_live = jobs_marked_as_live_on_careers_site.select do |job_marked_as_live_on_careers_site|
        # if the job previews don't include the live job url then the live job
        # must have been removed
        !job_previews_currently_on_careers_site.map(&:url).include?(job_marked_as_live_on_careers_site.url)
      end

      jobs_that_are_no_longer_live.each do |job|
        job.update!(live_on_careers_site: false)

        url = Rails.env.production? ? "https://www.rubyjobs.io/api/v1/jobs" : "http://localhost:3000/api/v1/jobs"

        body = {
          reference: job.id,
          live_on_careers_site: false
        }.to_json

        res = HTTParty.patch(
          url,
          {
            body: body,
            headers: {
              'Content-Type' => 'application/json',
              'Authorization' => "Bearer #{ENV["CUSTOMER_API_KEY"]}"
            }
          }
        )

        unless res.ok?
          additional = {
            job_id: job.id,
            response_message: res.msg,
            response_code: res.code,
            res_body: res.body
          }
          message = "Updating live_on_careers_site API patch request failed"
          SendToErrorMonitors.send_error(error: message, additional: additional)
        end
      end
    end
  end
end
