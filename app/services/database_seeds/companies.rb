module DatabaseSeeds
  class Companies
    COMPANIES_YAML = File.read(Rails.root.join("config", "companies.yml"))

    def self.call
      companies_config = YAML.load(COMPANIES_YAML)

      companies_config.each do |company_config|
        company = Company.find_by(name: company_config["name"])

        company ? update_company(company, company_config) : create_new_company(company_config)
      end
    end

    def self.update_company(company, company_config)
      company.careers_page_url = company_config["careers_page_url"]
      company.scraper_class = company_config["scraper_class"]

      company.save!
    end

    def self.create_new_company(company_config)
      # TODO: raise error if scraping class doesn't exist
      new_company = Company.new(
        name: company_config["name"],
        careers_page_url: company_config["careers_page_url"],
        scraper_class: company_config["scraper_class"]
      )

      new_company.save!
    end

    private_class_method :update_company, :create_new_company
  end
end


