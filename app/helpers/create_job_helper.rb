module CreateJobHelper
  def create_job(
      active: true,
      stack:,
      title:,
      level: Level.where(name: "junior").first_or_create,
      link:,
      company:,
      location:,
      degree_required:
  )
    job = Job.new(
        active: active,
        published_date: Date.today, # TODO: make this published date on the advert
        title: title,
        job_link: link,
        location: location,
        degree_required: degree_required
    )

    job.company = company
    job.level = level
    job.stack = stack

    job.save!
  end
end
