require 'open-uri'

module Scraping
  class GoogleScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_page = scrape_page(link: link, javascript_snippet: javascript, wait_time: 25000, custom_google: true, premium_proxy: true)

          # File.open("google_jobs_page_scrape.html", 'w') do |file|
          #   file.write scraped_page
          # end

          scraped_jobs = {}

          begin
            scraped_jobs = JSON.parse(scraped_page.search('#scraped-jobs').text)
          rescue => e
            puts "There are no google scraped jobs - #{Date.new}"
          end

          extract_and_save_job(scraped_jobs)
        end
      end
    end

    private

    def extract_and_save_job(scraped_jobs)
      scraped_jobs.each do |job|
        job_link = job["link"].gsub('utm_campaign=google_jobs_apply&utm_source=google_jobs_apply&utm_medium=organic', '')

        next if Job.where(job_link: job_link).count > 0

        new_job = Job.new(
            title: job["title"],
            job_link: job_link,
            location: job["location"],
            description: "",
            source: :google,
            status: "scraped",
            company: job["company"]
        )

        new_job.job_board = job["job_board"] if job["job_board"]

        new_job.save!
      end
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
