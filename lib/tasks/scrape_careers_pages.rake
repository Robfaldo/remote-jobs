task :scrape_careers_pages => :environment do
  companies_with_careers_pages = Company.where.not(careers_page_url: nil)

  companies_with_careers_pages.each do |company|
    Scraping::ScrapeCareersPage.new(company: company).call
  end

  jobs = Job.where(status: "scraped", source: "direct_from_careers_page")
  JobEvaluation::Pipeline.new(jobs).process

  JobPreview.created_over_n_days(3).all.destroy_all
end

