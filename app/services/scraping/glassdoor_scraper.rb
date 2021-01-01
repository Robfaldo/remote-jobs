module Scraping
  class GlassdoorScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_page = scrape_page(link: link, wait_time: 10000)

          scraped_jobs = scraped_page.search('.react-job-listing')

          jobs_to_evaluate = extract_jobs_to_evaluate(scraped_jobs)

          jobs_to_scrape = evaluate_jobs(jobs_to_evaluate)

          extract_and_save_job(jobs_to_scrape)
        end
      end
    end

    private

    def extract_jobs_to_evaluate(scraped_all_jobs_page)
      jobs_to_evaluate = []

      scraped_all_jobs_page.each do |job|
        link = 'https://www.glassdoor.co.uk' + job.search('a').first.get_attribute('href')
        company = job.search('.jobHeader').search('a').text.strip
        title = job.search('.jobTitle').text.strip
        location = job.search('.loc').text.strip

        jobs_to_evaluate.push(JobToEvaluate.new(title: title, link: link, company: company, location: location))
      end

      jobs_to_evaluate
    end

    def extract_and_save_job(evaluated_jobs)
      evaluated_jobs.each do |job|
        next if Job.where(source_id: job.link).count > 0  # we store original scraped job link as the id

        begin
          scraped_job_page = scrape_page(link: job.link, javascript_snippet: javascript, wait_time: 10000)

          create_job(job, scraped_job_page)
        rescue => e
          Rollbar.error(e, job: job.instance_values.to_s)
        end
      end
    end

    def create_job(job, scraped_job_page)
      description = scraped_job_page.search('.desc')[-1].text
      new_link = scraped_job_page.search('#current-url').first.text # the link changes after this page loads

      new_job = Job.new(
          title: job.title,
          job_link: new_link,
          location: job.location,
          description: description,
          source: :glassdoor,
          status: "scraped",
          company: job.company,
          job_board: "glassdoor",
          source_id: job.link
      )

      new_job.save!
    end

    def javascript
      %{
        (function () {
            setTimeout(function () {
                if (document.getElementsByClassName('ecgq1xb2').length > 0) {
                  document.getElementsByClassName('ecgq1xb2')[0].click(); // click the show more button
                };
                el = document.createElement('div');
                el.id = 'current-url';
                el.textContent = window.location.href;
                document.body.appendChild(el);
            }, 5000);
        })();
      }
    end
  end
end
