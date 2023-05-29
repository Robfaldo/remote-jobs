require 'open-uri'

module Scraping
  class GoogleScraper < DefaultScraper
    def get_jobs
      search_links.each do |location, data|
        links_to_scrape = Scraping::GetLinksForLocation.call(data)

        links_to_scrape.each do |link|
          scraped_page = scraper.scrape_page(link: link, javascript_snippet: javascript, wait_time: 25000, custom_google: true, premium_proxy: true)

          retrieved_jobs = scraped_page.search('#scraped-jobs').text

          job_previews = JSON.parse(retrieved_jobs)

          job_previews.each do |job|
            url = job["link"].gsub('utm_campaign=google_jobs_apply&utm_source=google_jobs_apply&utm_medium=organic', '')
            next if Job.where(url: url).count > 0

            begin
              create_job(job, url, location)
            rescue => e
              SendToErrorMonitors.send_error(error: e, additional: { job: job })
            end
          end
        end
      end
    end

    private

    def create_job(job, url, searched_location)
      if !job["location"]
        job["location"] = searched_location
      end

      new_job = Job.new(
          title: job["title"],
          url: url,
          location: job["location"],
          description: job["description"],
          source: :google,
          status: "scraped",
          company: CompanyServices::FindOrCreateCompany.call(job["company"]),
          scraped_company: job["company"]
      )

      save_job(new_job)
    end

    def javascript
      %{
        (function () {
            setTimeout(function () {
                let jobs = [];
                job_cards = Array.from(document.querySelectorAll("[jsname='DVpPy']"));

                for (i = 0; i < job_cards.length; i++) {
                  let title; let description; let company; let location; let link; let job_board; let company_node
                  let job_details = document.getElementById('tl_ditsc');

                  try {
                    job_cards[i].click();

                    title = job_details.querySelector('.KLsYvd').textContent;
                    company_node = job_details.querySelector('.nJlQNd');
                    company = company_node.textContent
                    link = job_details.querySelector('a.pMhGee').getAttribute('href')
                    job_board = job_details.querySelector('a.pMhGee').textContent.split("Apply on ").pop()
                    description = job_details.querySelector('.HBvzbc').textContent
                  } catch {};

                  try {
                    location = company_node.parentNode.childNodes[1].textContent
                  } catch {};

                  try {
                    job_details.querySelector('.cVLgvc').click()
                    description = job_details.querySelector('.HBvzbc').textContent
                  } catch {};

                  jobs.push({title: title, description: description, company: company, location: location, link: link, job_board: job_board});
                };

                el = document.createElement('div');
                el.id = 'scraped-jobs';
                el.textContent = JSON.stringify(jobs);
                document.body.appendChild(el);
            }, 15000);
        })();
      }
    end
  end
end
