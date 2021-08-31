module Scraping
  class TotaljobsScraper < DefaultScraper
    private

    def source
      :totaljobs
    end

    def scrape_all_jobs_page_options(link)
      {
        link: link,
        wait_time: 5000,
        premium_proxy: true,
        use_luminati: true
      }
    end

    def scrape_job_page_options(job)
      {
        link: job.job_link,
        premium_proxy: true,
        use_luminati: true
      }
    end

    def job_element
      '.job'
    end

    def job_element_company(job)
      job.search('h3').search('a').text
    end

    def job_element_title(job)
      job.search('h2').text.strip
    end

    def job_element_location(job)
      job.search('.location').search('span').first.text.strip
    end

    def job_element_link(job)
      job.search('.job-title').search('a').first.get_attribute('href')
    end

    def handle_pagination
      false
    end

    def pages_remaining_to_scrape(scraped_all_jobs_page)
      jobs_appearing_in_search = scraped_all_jobs_page.search('.page-title').search('span').first.text.to_i
      jobs_per_page = 20
      total_pages_to_scrape = (jobs_appearing_in_search / jobs_per_page.to_f).ceil
      total_pages_to_scrape - 1 # we already scraped the 1st page
    end

    def paginated_page_link(link, current_paginated_page)
      link + "&page=#{current_paginated_page + 1}"
    end

    def create_job(job, scraped_job_page)
      description = scraped_job_page.search('.job-description').text

      CreateJobService.call(
        title: job.title,
        job_link: job.job_link,
        location: job.location,
        description: description,
        source: source,
        status: "scraped",
        scraped_company: job.company,
        job_board: "Totaljobs",
        source_id: job.job_link,
        searched_location: job.searched_location,
        scraped_page_html: scraped_job_page.to_html
      )
    end
  end
end
