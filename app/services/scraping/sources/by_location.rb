module Scraping
  module Sources
    class ByLocation < Base
      def get_jobs
        search_links_for_all_locations.each do |location, data|
          links_for_location = Scraping::GetLinksForLocation.call(data)

          links_for_location.each do |link|
            options = scrape_all_jobs_page_options(link)
            job_page = ScrapePage.call(**options)
            job_previews = extract_job_previews_from_page(job_page, location)
            job_previews_to_scrape = decide_job_previews_to_scrape(job_previews)
            scrape_jobs(job_previews_to_scrape)
          rescue => e
            SendToErrorMonitors.send_error(error: e, additional: {link: link, location: location})
          end
        end
      end

      private

      def search_links_for_all_locations
        class_name_underscored = self.class.name.split("::").last.underscore
        search_links_file_path = Rails.root.join("config", "search_links", "#{class_name_underscored}.yml")
        YAML.load(File.read(search_links_file_path))
      end
    end
  end
end
