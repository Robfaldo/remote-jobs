module Scraping
  class CvLibraryScraper < DefaultScraper
    private

    def source
      :cv_library
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
      '.results__item'
    end

    def job_element_title(job)
      job.search('.job__title').text.gsub('Quick Apply', '').strip
    end

    def job_element_link(job)
      'https://www.cv-library.co.uk' + job.search('.job__title').search('a').first.get_attribute('href')
    end

    def create_job(job, scraped_job_page)
      location = scraped_job_page.search('//dd[@data-jd-location]').text
      first_description = scraped_job_page.search('.premium-description').text
      second_description = scraped_job_page.search('.job__description').text

      description = first_description == "" ? second_description : first_description

      if scraped_job_page.search('//dd[@data-jd-company]').text.strip != ""
        scraped_company = scraped_job_page.search('//dd[@data-jd-company]').text.strip
      elsif scraped_job_page.search('//span[@data-jd-company]').text.strip != ""
        scraped_company = scraped_job_page.search('//span[@data-jd-company]').text.strip
      elsif scraped_job_page.search('.bg-border > .job__details-value a').text.strip != ""
        scraped_company = scraped_job_page.search('.bg-border > .job__details-value a').text.strip
      elsif scraped_job_page.search('//*[contains(concat( " ", @class, " " ), concat( " ", "job__details-value", " " ))]//a').text.strip != ""
        scraped_company = scraped_job_page.search('//*[contains(concat( " ", @class, " " ), concat( " ", "job__details-value", " " ))]//a').text.strip
      end

      new_job = Job.new(
          title: scraped_job_page.search('//span[@data-jd-title]').text,
          job_link: job.job_link,
          location: location,
          description: description,
          source: source,
          status: "scraped",
          company: CompanyServices::FindOrCreateCompany.call(scraped_company),
          scraped_company: scraped_company,
          source_id: job.job_link,
          job_board: "cv_library",
          searched_location: job.searched_location
      )

      save_job(new_job, scraped_job_page)
    end
  end
end
