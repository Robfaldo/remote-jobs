module Scraping
	class CwjobsScraper < DefaultScraper
		private

		def source
			:cwjobs
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
				link: job.url,
				premium_proxy: true,
				use_luminati: true
			}
		end

		def job_element
			'.job'
		end

		def job_element_company(job)
			job.search('.company').search('h3').text.strip
		end

		def job_element_title(job)
			job.search('.job-title').search('h2').text.strip
		end

		def job_element_link(job)
			job.search('.job-title').search('a').first.get_attribute('href')
		end

		def create_job(job, scraped_job_page)
			location = scraped_job_page.search('.location').text.split('jobs in ').last
			description = scraped_job_page.search('.job-description').text

			new_job = Job.new(
				title: job.title,
				url: job.url,
				location: location,
				description: description,
				source: source,
				status: "scraped",
				company: CompanyServices::FindOrCreateCompany.call(job.company),
				scraped_company: job.company,
				source_id: job.url
			)

			save_job(new_job, scraped_job_page)
		end
	end
end
