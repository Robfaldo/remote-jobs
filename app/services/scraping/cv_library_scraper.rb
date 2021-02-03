module Scraping
  class CvLibraryScraper < DefaultScraper

    private

    def scrape_all_jobs_page_options(link)
      {
        link: link,
        wait_time: 10000
      }
    end

    def scrape_job_page_options(job)
      {
        link: job.link
      }
    end

    def job_element
      '.results__item'
    end

    def job_element_title(job)
      job.search('.job-title').search('h2').text
    end

    def job_element_link(job)
      'https://www.cv-library.co.uk' + job.search('.job__title').search('a').first.get_attribute('href')
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
