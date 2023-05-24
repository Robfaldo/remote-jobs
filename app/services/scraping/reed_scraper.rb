module Scraping
	class ReedScraper < DefaultScraper
		private

		def source
			:reed
		end

		def scrape_all_jobs_page_options(link)
			{
				link: link,
				wait_time: 5000,
				premium_proxy: true
			}
		end

		def scrape_job_page_options(job)
			{
				link: job.job_link
			}
		end

		def job_element
			'.job-result'
		end

		def job_element_title(job)
			job.search('.title').text.strip
		end

		def job_element_link(job)
			'https://www.reed.co.uk' + job.search('.title').search('a').first.get_attribute('href')
		end

		def create_job(job, scraped_job_page)
			location = scraped_job_page.xpath("//span[@itemprop='addressLocality']").first.text.strip
			company = scraped_job_page.xpath("//span[@itemprop='name']").first.text.strip
			description = scraped_job_page.search('.description').first&.text || scraped_job_page.xpath("//span[@itemprop='name']").first.text

			new_job = Job.new(
				title: job.title,
				job_link: job.job_link,
				location: location,
				description: description,
				source: source,
				status: "scraped",
				company: CompanyServices::FindOrCreateCompany.call(company),
				scraped_company: company,
				job_board: "Reed",
				source_id: job.job_link
			)

			save_job(new_job, scraped_job_page)
		end
	end
end
