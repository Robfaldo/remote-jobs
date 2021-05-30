module Scraping
  class JobserveScraper < DefaultScraper
    private

    def source
      :jobserve
    end

    def scrape_all_jobs_page_options(link)
      {
        link: link,
        wait_time: 5000
      }
    end

    def scrape_job_page_options(job)
      {
        link: job.job_link
      }
    end

    def job_element
      '.jobListItem'
    end

    def job_element_title(job)
      job.search('.jobListPosition').text
    end

    def job_element_location(job)
      job.search('#summlocation').first.text
    end

    def job_element_link(job)
      'https://www.jobserve.com' + job.search('.jobListPosition').first.get_attribute('href')
    end

    def create_job(job, scraped_job_page)
      company = scraped_job_page.search('#td_posted_by').first.text.gsub('Posted by: ', '')
      description = scraped_job_page.search('#md_skills').text

      new_job = Job.new(
          title: job.title,
          job_link: job.job_link,
          location: job.location,
          description: description,
          source: source,
          status: "scraped",
          company: company,
          job_board: "Jobserve",
          source_id: job.job_link,
          searched_location: job.searched_location
      )

      save_job(new_job, scraped_job_page)
    end
  end
end
