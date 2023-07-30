# This is a "data transfer object". Its purpose is to encapsulate data to be sent to somewhere
class JobDto
  attr_reader :reference, :title, :location, :longitude, :latitude,
              :description, :datetime_posted, :company, :company_id,
              :remote_status, :url, :levels, :source

  def initialize(job)
    @reference = job.id
    @title = job.title
    @location = job.location
    @longitude = job.longitude
    @latitude = job.latitude
    @description = job.description
    @datetime_posted = job.created_at
    @company = job.company.name
    @company_id = job.company.id
    @fully_remote = job.remote_status == "fully_remote"
    @url = job.url
    @levels = get_levels_from_tags(job)
    @source = job.source
    @in_london = job.london_based?
  end

  private

  def get_levels_from_tags(job)
    all_levels = ["grad", "junior", "mid", "senior", "staff", "lead", "principle"]
    all_levels.intersection(job.tags.map(&:name))
  end
end
