module Scraping
  class TotaljobsScraper < Scraper
    MAX_GROUP_PAGES_TO_SCRAPE = 2 #TODO: rename this, can't think of better
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          # have to use premium because need UK location
          scraped_page = scrape_page(link: link, wait_time: 5000, premium_proxy: true, use_zenscrape: true)

          scrape_and_save_jobs(scraped_page)

          ## Handle Pagination
          extra_pages = calculate_additional_pages(scraped_page)

          scrape_additional_pages(extra_pages, link)
        end
      end
    end

    private

    def scrape_additional_pages(extra_pages, link)
      extra_pages.times do |page|
        current_page = page + 2 # page will start at 0, and the first page (i.e. first additional page after the original page scrape) we want to scrape is 2

        break if current_page > MAX_GROUP_PAGES_TO_SCRAPE

        link_to_scrape = link + "&page=#{current_page}"

        scraped_page = scrape_page(link: link_to_scrape, wait_time: 5000, premium_proxy: true, use_zenscrape: true)

        scrape_and_save_jobs(scraped_page)
      end
    end

    def calculate_additional_pages(scraped_page)
      jobs_appearing_in_search = scraped_page.search('.page-title').search('span').first.text.to_i
      jobs_per_page = 20
      total_pages_to_scrape = (jobs_appearing_in_search / jobs_per_page.to_f).ceil
      total_pages_to_scrape - 1 # we already scraped the 1st page
    end

    def scrape_and_save_jobs(scraped_page)
      scraped_jobs = scraped_page.search('.job')

      jobs_to_evaluate = jobs_to_evaluate(scraped_jobs)

      jobs_to_scrape = evaluate_jobs(jobs_to_evaluate)

      extract_and_save_job(jobs_to_scrape)
    end

    def jobs_to_evaluate(scraped_all_jobs_page)
      jobs_to_evaluate = []

      scraped_all_jobs_page.each do |job|

        begin
          job_to_evaluate = extract_job_to_evaluate(job)

          jobs_to_evaluate.push(job_to_evaluate)
        rescue => e
          Rollbar.error(e)
        end
      end

      jobs_to_evaluate
    end

    def extract_job_to_evaluate(job)
      link = job.search('.job-title').search('a').first.get_attribute('href')
      company = job.search('h3').search('a').text
      title = job.search('h2').text.strip
      location = job.search('.location').search('span').first.text.strip

      JobToEvaluate.new(title: title, link: link, company: company, location: location)
    end

    def extract_and_save_job(evaluated_jobs)
      evaluated_jobs.each do |job|
        next if Job.where(job_link: job.link).count > 0

        begin
          scraped_job_page = scrape_page(link: job.link, premium_proxy: true, use_zenscrape: true)

          create_job(job, scraped_job_page)
        rescue => e
          Rollbar.error(e, job: job.instance_values.to_s)
        end
      end
    end

    def create_job(job, scraped_job_page)
      description = scraped_job_page.search('.job-description').text

      new_job = Job.new(
          title: job.title,
          job_link: job.link,
          location: job.location,
          description: description,
          source: :totaljobs,
          status: "scraped",
          company: job.company,
          job_board: "Totaljobs",
          source_id: job.link
      )

      new_job.save!
    end
  end
end
