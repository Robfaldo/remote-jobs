module Scraping
  class IndeedScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_page = scrape_page(link: link, wait_time: 10000)

          scrape_and_save_jobs(scraped_page)

          ## Handle Pagination
          jobs_appearing_in_search = scraped_page.search('#searchCountPages').text.strip.gsub('Page 1 of ', '').gsub(' jobs', '').to_i
          jobs_per_page = 15
          total_pages_to_scrape = (jobs_appearing_in_search / jobs_per_page.to_f).ceil
          pages_remaining_to_scrape = total_pages_to_scrape - 1 # we already scraped the 1st page

          scrape_additional_pages(pages_remaining_to_scrape, link)
        end
      end
    end

    private

    def scrape_additional_pages(pages_remaining_to_scrape, link)
      pages_remaining_to_scrape.times do |num|
        # if it's the 1st extra page (2nd total page) start at "&start=10", 2nd page "&start=0" etc..
        link_to_scrape = link + "&start=#{num + 1}0"

        scraped_page = scrape_page(link: link_to_scrape, wait_time: 10000)

        scrape_and_save_jobs(scraped_page)
      end
    end

    def scrape_and_save_jobs(scraped_page)
      scraped_jobs = scraped_page.search('.jobsearch-SerpJobCard')

      jobs_to_evaluate = jobs_to_evaluate(scraped_jobs)

      jobs_to_scrape = evaluate_jobs(jobs_to_evaluate)

      extract_and_save_job(jobs_to_scrape)
    end

    def jobs_to_evaluate(scraped_jobs)
      jobs_to_evaluate = []

      scraped_jobs.each do |job|
        begin
          extracted_job = extract_job_to_evaluate(job)

          jobs_to_evaluate.push(extracted_job)
        rescue => e
          Rollbar.error(e)
        end
      end

      jobs_to_evaluate
    end

    def extract_job_to_evaluate(job)
      scraped_link = job.search('.title').search('a').first.get_attribute('href')
      link = 'https://www.indeed.co.uk/viewjob' + scraped_link.gsub('/rc/clk', '')
      company = job.search('.company').search('a').text.strip
      title = job.search('.title').search('a').text.strip
      location = job.search('.location').text

      JobToEvaluate.new(title: title, link: link, company: company, location: location)
    end

    def extract_and_save_job(evaluated_jobs)
      evaluated_jobs.each do |job|
        next if Job.where(job_link: job.link).count > 0

        begin
          description = get_job_description(job)

          create_job(job, description)
        rescue => e
          Rollbar.error(e, job: job.instance_values.to_s)
        end
      end
    end

    def get_job_description(job)
      scraped_job_page = scrape_page(link: job.link)

      scraped_job_page.search('#jobDescriptionText').text
    end

    def create_job(job, description)
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
