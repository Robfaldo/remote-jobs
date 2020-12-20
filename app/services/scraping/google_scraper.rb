require 'open-uri'

module Scraping
  class GoogleScraper < Scraper
    def get_jobs
      link = "https://www.google.com/search?q=junior+software+developer+jobs+london&rlz=1C5CHFA_enGB775GB776&oq=jobs&aqs=chrome..69i57j0i271l3j69i60l4.793j0j1&sourceid=chrome&ie=UTF-8&ibp=htl;jobs&sa=X&ved=2ahUKEwibybmL2drtAhVPY8AKHVwtAxYQutcGKAB6BAgEEAQ&sxsrf=ALeKk003knj-0TE9_a6mWHNDf4XnpZn5Eg:1608403267781#fpstate=tldetail&htivrt=jobs&htilrad=8.0467&htichips=date_posted:today&htischips=date_posted;today&htidocid=NXW9wfYw7Il5cPYjAAAAAA%3D%3D"

      javascript = %{
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

      scraper = Scraper.new

      scraped_page = scraper.scrape_page(link: link, javascript_snippet: javascript, wait_time: 25000, custom_google: true)

      File.open("google_jobs_page_scrape.html", 'w') do |file|
        file.write scraped_page
      end

      scraped_jobs = {}

      begin
        scraped_jobs = JSON.parse(scraped_page.search('#scraped-jobs').text)
      rescue => e
        puts "There are no google scraped jobs - #{Date.new}"
      end

      jobs = []

      scraped_jobs.each do |job|
        jobs.push(
          ScrapedJob.new(
            title: job["title"],
            company: job["company"],
            link: job["link"].gsub('utm_campaign=google_jobs_apply&utm_source=google_jobs_apply&utm_medium=organic', ''),
            location: job["location"],
            description: job["description"],
            job_board: job["job_board"],
            source: :google
          )
        )
      end

      jobs
    end
  end
end
