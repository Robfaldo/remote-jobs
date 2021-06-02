module CompanyServices
  class GetCompanyTechnologies
    def self.single_company(company:)
      # https://stackoverflow.com/questions/67784484/rails-merge-common-attributes-on-a-has-many-through-model-to-show-unique-valu
      # This will return an array, with each item an array of 3 items (technology_id, total title_matches, total title_descriptions)
      # So if Company X has 2 jobs:
      #    * Job 1 has 'Ruby' JobTechnology with 1x title_match, 2x description_match
      #    * Job 2 has 'Ruby' JobTechnology with 0x title_match, 7x description_match
      # Then Company.find(x).technologies would result in:
      #    => [[10, 1, 9]] which is [[technology_id, total title_matches, total_description]]
      technologies_with_occurrence_data = company.job_technologies.group(:technology_id).pluck(
        :technology_id,
        JobTechnology.arel_table[:title_matches].sum,
        JobTechnology.arel_table[:description_matches].sum
      )

      technologies_with_occurrence_data.map do |technology_data|
        technology_id = technology_data.first
        title_matches = technology_data.second
        description_matches = technology_data.third

        CompanyTechnology.new(
          technology: Technology.find(technology_id),
          title_matches: title_matches,
          description_matches: description_matches
        )
      end
    end
  end
end
