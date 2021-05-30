module Scraping
  class GetLinksForLocation
    def self.call(data)
      links_to_scrape = data["links"]

      if data["search_by_technology"]
        links_to_scrape.concat(search_by_technology_links(data["search_by_technology_url_pattern"]))
      end

      links_to_scrape
    end

    def self.search_by_technology_links(url_pattern)
      technologies_in_groups = Technology.all_names_including_aliases.in_groups_of(10)

      links = []

      technologies_in_groups.each do |group_of_technologies|
        technologies = group_of_technologies.reject{|technology| technology == nil}
        url_safe_technologies = technologies.map{ |technology| CGI.escape(technology) }

        new_link = url_pattern.gsub("ADDTECHNOLOGIESHERE", url_safe_technologies.join("+OR+"))

        links.push(new_link)
      end

      links
    end
  end
end
