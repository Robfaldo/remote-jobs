module Api
  module V1
    class JobsController < ActionController::API
      def create
        url = if params["direct_company_link"] == "N/A"
                     params["source_link"]
                   else
                     params["direct_company_link"]
                   end

        job = Job.new(
          title: params["title"],
          url: url,
          location: params["location"],
          description: params["description"],
          source: params["source"],
          status: "scraped",
          company: CompanyServices::FindOrCreateCompany.call(params["company"]),
          scraped_company: params["company"],
          source_id: params["source_link"]
        )
        job.save!

        JobEvaluation::Pipeline.new([job]).process
      end
    end
  end
end
