module Scraping
  class GlassdoorScraper < Scraper
    LOCATIONS = ["London"]

    def get_jobs
      LOCATIONS.each do |location|
        search_links[location].each do |link|
          scraped_all_jobs_page = scrape_page(link: link, wait_time: 10000)

          links = get_links(scraped_all_jobs_page)

          extract_and_save_job(links)
        end
      end
    end

    private

    def remove_rating(company)
      company.split("")[0..-5].join
    end

    def get_links(scraped_page)
      link_elements = scraped_page.search('.react-job-listing')

      links = []

      link_elements.each do |element|
        link = element.search('a').first.get_attribute('href')
        links.push('https://www.glassdoor.co.uk' + link)
      end

      links
    end

    def extract_and_save_job(links)
      links.each do |source_link|
        next if Job.where(source_id: source_link).count > 0

        scraped_job_page = scrape_page(link: source_link, javascript_snippet: javascript, wait_time: 10000)

        title = scraped_job_page.search('.e11nt52q6')[0].text
        location = scraped_job_page.search('.e11nt52q2')[0].text
        salary = scraped_job_page.search('.e1v3ed7e1')[0].text if scraped_job_page.search('.e1v3ed7e1').count > 0
        company_with_rating = scraped_job_page.search('.e11nt52q1')[0].text
        company = remove_rating(company_with_rating)
        description = scraped_job_page.search('.desc')[-1].text
        new_link = scraped_job_page.search('#current-url').first.text # the link changes after this page loads

        new_job = Job.new(
            title: title,
            job_link: new_link,
            location: location,
            description: description,
            source: :glassdoor,
            status: "scraped",
            company: company,
            source_id: source_link,
            job_board: "glassdoor",
            salary: salary
        )

        new_job.save!
      end
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
