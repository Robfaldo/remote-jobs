module Scraping
  class IndeedScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_page = scrape_page(link: link, wait_time: 10000)

          scraped_jobs = scraped_page.search('.jobsearch-SerpJobCard')

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
        scraped_link = job.search('.title').search('a').first.get_attribute('href')
        link = 'https://www.indeed.co.uk/viewjob' + scraped_link.gsub('/rc/clk', '')
        company = job.search('.company').search('a').text.strip
        title = job.search('.title').search('a').text.strip
        location = job.search('.location').text

        jobs_to_evaluate.push(JobToEvaluate.new(title: title, link: link, company: company, location: location))
      end

      jobs_to_evaluate
    end

    def extract_and_save_job(evaluated_jobs)
      evaluated_jobs.each do |job|
        next if Job.where(job_link: job.link).count > 0

        scraped_job_page = scrape_page(link: job.link)

        description = scraped_job_page.search('#jobDescriptionText').text

        new_job = Job.new(
            title: job.title,
            job_link: job.link,
            location: job.location,
            description: description,
            source: :indeed,
            status: "scraped",
            company: job.company,
            job_board: "Indeed",
            source_id: job.link
        )

        new_job.save!
      end
    end
  end
end
