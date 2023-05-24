class Technology < ApplicationRecord
  has_many :job_technologies
  has_many :jobs, through: :job_technologies

  validates :name, presence: true
  validates :aliases, presence: true
  validates :is_language, inclusion: [true, false]
  validates :is_framework, inclusion: [true, false]
  validates :used_for_frontend, inclusion: [true, false]
  validates :used_for_backend, inclusion: [true, false]

  def self.all_languages_names
    languages = all.select{|t| t.is_language}
    languages.map(&:name)
  end

  def self.all_frameworks_names
    frameworks = all.select{|t| t.is_framework}
    frameworks.map(&:name)
  end

  def self.all_names_including_aliases
    all_names.concat(aliases_for(technologies: all))
  end

  def parsed_aliases
    JSON.parse(aliases)
  end

  def self.all_names
    all.map(&:name)
  end

  def self.aliases_for(technologies:)
    aliases = technologies.map(&:aliases)

    aliases.reject! {|a| a == "[]"} # we don't want empty aliases

    all_aliases = aliases.map do |a|
      JSON.parse(a)
    end

    all_aliases.flatten
  end
end
