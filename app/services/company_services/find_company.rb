module CompanyServices
  class FindCompany
    def self.call(company_name)
      return nil unless company_name
      return nil if company_name == ""

      ###################### First Fuzzy match
      name_to_search = clean_company_name(company_name)
      # First use the provided company name to fuzzy match it to companies in the database
      companies_found_in_database = search_database_for_company(name_to_search)

      rollbar_for_multiple_companies(company_name, companies_found_in_database) if companies_found_in_database.count > 1
      return companies_found_in_database.first if companies_found_in_database.first
      ###################### /First Fuzzy match

      ###################### Second Fuzzy match
      # If we couldn't find a match above then get all the companies from the database and
      # fuzzy match them against the provided company name
      companies_found_from_inverse_search = search_all_existing_companies(company_name)

      # This second search is quite intensive, especially as we do it so often. I'm curious how often
      # it will actually provide a match that the above didn't. If this isn't triggered much then
      # I should remove it to cut down on the operation costs of this service
      Rollbar.info('The second fuzzy match was successful') if companies_found_from_inverse_search.count > 0

      rollbar_for_multiple_companies(company_name, companies_found_from_inverse_search) if companies_found_from_inverse_search.count > 1
      return companies_found_from_inverse_search.first if companies_found_from_inverse_search.first
      ###################### /Second Fuzzy match

      nil # Return nil if nothing was matched
    end

    private

    def self.rollbar_for_multiple_companies(company_name, matched_names)
      # I'm interested how often this will happen and I think having this here will help
      # debug.
      message = %{
        More than 1 company found when searching for: #{company_name}
        There were #{matched_names.count} matches.
        The matches were: #{matched_names.to_ary}
      }
      Rollbar.info(message)
    end

    def self.search_all_existing_companies(name_to_search)
      all_existing_company_names = Company.all.map{|company| { company.name => company.id }}

      matching_existing_company_ids = []

      all_existing_company_names.each do |existing_company_name, existing_company_id|
        # If the name to search begins with the company name (and has anything afterwards)
        # So 'Apple' would match 'AppleInc' and 'Apple.inc' and 'Apple inc' etc
        # Ignore cases (the 'i' does that)
        if /^#{existing_company_name}*/i.match(name_to_search)
          matching_existing_company_ids.push(existing_company_id)
        end
        # I almost used the below to only allow a space, '.', ',' or '-' after the company name.
        # If I find that the pure wildcard is making too many false positives then I can use this
        # /^#{existing_company_name}[\s.,-]/.match(name_to_search)
      end

      matching_existing_company_ids
    end

    def self.search_database_for_company(name_to_search)
      # Add a wildcard to the end of the name (to catch things like 'Company Name Ltd' when searching for 'Company Name')
      # lower(name) downcases the name from the database
      Company.where("lower(name) LIKE ?", "#{name_to_search}%")
    end

    def self.clean_company_name(company_name)
      # Downcase and remove non alpha-numeric characters
      name = company_name.downcase.gsub(/[^[:word:]\s]/, ' ')
      # Remove all additional suffixes like ltd and plc
      remove_common_extras(name)
    end

    def self.remove_common_extras(name)
      # I'm doing this because I'm imagining a scenario where we
      # have 'Apple Inc' in the database and we search for
      # 'Apple plc'. I don't know how common this would be
      # (very uncommon imo) but it seems like an easy step to add.
      name.gsub(' ltd', '')
          .gsub(' ltd ', '')
          .gsub(' ltd.')
          .gsub(' ltd. ')
          .gsub(' pvt', '')
          .gsub(' pvt ', '')
          .gsub(' limited', '')
          .gsub(' limited ', '')
          .gsub(' plc', '')
          .gsub(' plc ', '')
          .gsub(' plc.', '')
          .gsub(' plc. ', '')
          .gsub(' llc', '')
          .gsub(' llc ', '')
    end
  end
end

  # This is the logic I've followed for doing this fuzzy matching of finding a company.
  # Here's the link but out of fear that it gets removed I've copy/pasted the main part below
  # https://www.notion.so/How-to-block-companies-b83c2b5dad354b4ca206efa6eda7267a
  # NB: I added stripping the common suffixes (plc, llc etc...). I may want to remove this

  ### What does this block?
  # Blocking a company prevents said company from finding you on Cord. This is done by comparing the company's name against the companies that you have blocked.
  # As there is a certain degree of variability in company names, we fuzzy match the names based on the following criteria:
  #
  # 1. All characters are converted to lowercase
  # 2. Non-alphanumeric characters are stripped (IE: spaces, punctuation, special characters)
  # 3. A wildcard is applied to the end of the names of companies you have blocked
  # 4. A wildcard is applied to the end of the name of the company that is looking for engineers
  #
  # Let's dive into what each criteria does:
  #
  # **#1 All characters are converted to lowercase**
  #
  # This is straightforward. It allows us to match `viagogo` against `Viagogo`
  #
  # **#2 Non-alphanumeric characters are stripped**
  #
  # This ensures `Signal A.I.` is matched against `Signal AI`
  #
  # **#3 Wildcard is applied to the end of the names of companies you have blocked**
  #
  # Occasionally, company names will contain additional terms such as `hq`, `.io`, `ltd` or `uk`.
  #
  # If you have blocked `Vonage`, if the company `Vonage UK` attempts to search for you, they will
  # be blocked from doing so
  #
  # **#4 Wildcard is applied to the end of the name of the company that is looking for engineers**
  #
  # This is the inverse of #3. If you have blocked `faceitltd`, if the company `faceit` attempts to
  # search for you, they will be blocked.
