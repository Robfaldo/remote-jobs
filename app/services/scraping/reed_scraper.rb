module Scraping
	class ReedScraper < DefaultScraper
		private

		def scrape_all_jobs_page_options(link)
			{
				link: link,
				wait_time: 5000,
				premium_proxy: true
			}
		end

		def scrape_job_page_options(job)
			{
				link: job.link
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
			description = scraped_job_page.search('.description').first.text

			new_job = Job.new(
				title: job.title,
				job_link: job.link,
				location: location,
				description: description,
				source: :reed,
				status: "scraped",
				company: company,
				job_board: "Reed",
				source_id: job.link
			)

			new_job.save!
		end
	end
end
