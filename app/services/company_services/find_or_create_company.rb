module CompanyServices
  class FindOrCreateCompany
    def self.call(company_name)
      return if company_name == ""
      return unless company_name

      existing_company = CompanyServices::FindCompany.call(company_name)

      if existing_company
        return existing_company
      else
        new_company = Company.new(name: company_name)
        new_company.save!
        new_company
      end
    end
  end
end
