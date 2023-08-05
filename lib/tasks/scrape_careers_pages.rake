task :scrape_careers_pages => :environment do
  companies_with_careers_pages = Company.where.not(careers_page_url: nil)

  companies_with_careers_pages.each do |company|
    Scraping::ScrapeCareersPage.new(company: company).call
  end
end
