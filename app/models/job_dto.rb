# This is a "data transfer object". Its purpose is to encapsulate data to be sent to somewhere
class JobDto
  attr_reader :reference, :title, :locations, :description, :datetime_posted, :company, :company_id,
              :remote_status, :url, :levels, :source, :location_on_advert, :live_on_careers_site

  def initialize(job)
    @reference = job.id
    @title = job.title
    @locations = locations(job)
    @location_on_advert = job.location
    @description = job.description
    @datetime_posted = job&.job_posting_schema["datePosted"] || job.created_at
    @company = job.company.name
    @company_id = job.company.id
    @url = job.url
    @levels = get_levels_from_tags(job)
    @source = job.source
    @live_on_careers_site = job.live_on_careers_site
  end

  private

  def locations(job)
    locations = []

    locations << "london" if job.london_based?
    locations << "fully remote" if job.remote_status == "fully remote"

    locations
  end

  def get_levels_from_tags(job)
    all_levels = ["grad", "junior", "mid", "senior", "staff", "lead", "principle"]
    all_levels.intersection(job.tags.map(&:name))
  end
end
