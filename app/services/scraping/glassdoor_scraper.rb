module Scraping
  class GlassdoorScraper < DefaultScraper
    private

    def source
      :glassdoor
    end

    def scrape_all_jobs_page_options(link)
      {
        link: link,
        wait_time: 20000,
        premium_proxy: true,
        use_bee: true
      }
    end

    def scrape_job_page_options(job)
      {
        link: job.job_link,
        javascript_snippet: javascript,
        wait_time: 10000,
        premium_proxy: true,
        use_bee: true
      }
    end

    def job_element
      '.react-job-listing'
    end

    def job_element_title(job)
      job.search('.jobLink').search('span').last.text
    end

    def job_element_link(job)
      'https://www.glassdoor.co.uk' + job.search('.jobLink').first.get_attribute('href')
    end

    def job_element_company(job)
      job.search('.jobLink').search('span')[1].text
    end

    def job_element_location(job)
      job.search('.e1rrn5ka0').text
    end

    def create_job(job, scraped_job_page)
      description = scraped_job_page.search('.desc')[-1].text
      new_link = scraped_job_page.search('#current-url').first.text # the link changes after this page loads

      if field_empty?(job.company)
        rating = scraped_job_page.search('.e11nt52q1').first.search('span').first&.text
        company = scraped_job_page.search('.e11nt52q1').first.text.strip
        company.gsub(rating, '') if rating # doesn't always have a rating
      else
        company = job.company
      end

      CreateJobService.call(
        title: job.title,
        job_link: new_link,
        location: job.location,
        description: description,
        source: source,
        status: "scraped",
        scraped_company: company,
        job_board: "glassdoor",
        source_id: job.job_link,
        searched_location: job.searched_location,
        scraped_page_html: scraped_job_page.to_html
      )
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
