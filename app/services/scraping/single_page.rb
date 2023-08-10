module Scraping
  class SinglePage
    def self.call(company_name)
      companies_with_careers_pages = [Company.find_by(name: company_name)]
      companies_with_careers_pages.each do |company|
        Scraping::ScrapeCareersPage.new(company: company).call
      end
      jobs = Job.where(status: "scraped", source: "direct_from_careers_page")
      JobEvaluation::Pipeline.new(jobs).process
    end
  end
end
