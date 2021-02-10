module Scraping
  class IndeedScraper < DefaultScraper
    private

    def source
      :indeed
    end

    def scrape_all_jobs_page_options(link)
      {
        link: link,
        wait_time: 10000
      }
    end

    def scrape_job_page_options(job)
      {
        link: job.job_link
      }
    end

    def job_element
      '.jobsearch-SerpJobCard'
    end

    def job_element_company(job)
      job.search('.company').search('a').text.strip
    end

    def job_element_title(job)
      job.search('.title').search('a').text.strip
    end

    def job_element_location(job)
      job.search('.location').text
    end

    def job_element_link(job)
      scraped_link = job.search('.title').search('a').first.get_attribute('href')

      'https://www.indeed.co.uk/viewjob' + scraped_link.gsub('/rc/clk', '')
    end

    def handle_pagination
      true
    end

    def pages_remaining_to_scrape(scraped_all_jobs_page)
      jobs_appearing_in_search = scraped_all_jobs_page.search('#searchCountPages').text.strip.gsub('Page 1 of ', '').gsub(' jobs', '').to_i
      jobs_per_page = 15
      total_pages_to_scrape = (jobs_appearing_in_search / jobs_per_page.to_f).ceil

      total_pages_to_scrape - 1 # we already scraped the 1st page
    end

    def paginated_page_link(link, current_paginated_page)
      # if it's the 1st extra page (2nd total page) start at "&start=10",
      # 2nd page "&start=20" etc..
      link + "&start=#{current_paginated_page}0"
    end

    def create_job(job, scraped_job_page)
      description = scraped_job_page.search('#jobDescriptionText').text

      if job.company == ""
        job.company = scraped_job_page.xpath('//div[contains(@class, "companyrating")]').first.text
      end

      new_job = Job.new(
          title: job.title,
          job_link: job.job_link,
          location: job.location,
          description: description,
          source: source,
          status: "scraped",
          company: job.company,
          job_board: "Indeed",
          source_id: job.job_link
      )

      save_job(new_job, scraped_job_page)
    end
  end
end
