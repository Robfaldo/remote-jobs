module Scraping
  module Sources
    class FromSingleLink < Base
      def get_jobs
        job_page = ScrapePage.call(**scrape_all_jobs_page_options)
        job_previews = extract_job_previews_from_page(job_page)
        job_previews_to_scrape = decide_job_previews_to_scrape(job_previews)
        scrape_jobs(job_previews_to_scrape)
      rescue => e
        SendToErrorMonitors.send_error(error: e, additional: {link: scrape_all_jobs_page_options[:link]})
      end
    end
  end
end
