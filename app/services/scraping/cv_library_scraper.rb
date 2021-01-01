module Scraping
  class CvLibraryScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_all_jobs_page = scrape_page(link: link, wait_time: 10000)
          scraped_jobs = scraped_all_jobs_page.search('.results__item')

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
        title = job.search('.job__title').text.gsub('Quick Apply', '').strip
        link = 'https://www.cv-library.co.uk' + job.search('.job__title').search('a').first.get_attribute('href')

        jobs_to_evaluate.push(JobToEvaluate.new(title: title, link: link))
      end

      jobs_to_evaluate
    end

    def extract_and_save_job(jobs)
      jobs.each do |job|
        next if Job.where(source_id: job.link).count > 0

        begin
          scraped_job_page = scrape_page(link: job.link)

          create_job(job, scraped_job_page)
        rescue => e
          Rollbar.error(e, job.instance_values.to_s)
        end
      end
    end

    def create_job(job, scraped_job_page)
      location = scraped_job_page.search('//dd[@data-jd-location]').text
      first_description = scraped_job_page.search('.premium-description').text
      second_description = scraped_job_page.search('.job__description').text

      description = first_description == "" ? second_description : first_description

      new_job = Job.new(
          title: scraped_job_page.search('//span[@data-jd-title]').text,
          job_link: job.link,
          location: location,
          description: description,
          source: :cv_library,
          status: "scraped",
          company: scraped_job_page.search('//dd[@data-jd-company]').text.strip,
          source_id: job.link,
          job_board: "cv_library"
      )

      new_job.save!
    end
  end
end
