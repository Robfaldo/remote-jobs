class CreateJobService
  def self.call(title:,
                job_link:,
                location:,
                description:,
                source:,
                scraped_company:,
                job_board:,
                source_id: nil,
                searched_location:,
                scraped_page_html: nil,
                status:)

    company = CompanyServices::FindOrCreateCompany.call(scraped_company)

    new_job = Job.new(
      title: title,
      job_link: job_link,
      location: location,
      description: description,
      source: source,
      status: status,
      company: company,
      scraped_company: scraped_company,
      job_board: job_board,
      source_id: source_id,
      searched_location: searched_location
    )

    begin
      new_job.save!
    rescue => e
      rollbar_error = SendToErrorMonitors.send_error(error e, additional: { job: job.attributes })

      if scraped_page_html
        job_for_email = {
          title: title,
          job_link: job_link,
          location: location,
          # description: description, # Don't send description
          source: source,
          company: company,
          scraped_company: scraped_company,
          job_board: job_board,
          source_id: source_id,
          searched_location: searched_location,
          status: status
        }

        ScraperMailer.job_save_error_html(
          html: scraped_page_html,
          job: job_for_email.to_s,
          error: e,
          rollbar_uuid: rollbar_error[:uuid]
        ).deliver_now
      end
    end
  end
end
