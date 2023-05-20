module Api
  module V1
    class JobsController < ActionController::API
      def create
        SendToErrorMonitors.send_notification(message: "Job creation started through API",
                                              additional: params)

        job = Job.new(
          title: params["title"],
          job_link: params["direct_company_link"],
          location: params["location"],
          description: params["description"],
          source: params["source"],
          status: "scraped",
          company: CompanyServices::FindOrCreateCompany.call(params["company"]),
          scraped_company: params["company"],
          source_id: params["source_link"],
          searched_location: params["searched_location"]
        )
        job.save!

        JobTags::TagJobs.new([job]).call
        JobFiltering::FilterJobs.new([job]).call
      end
    end
  end
end
