module CreateJobHelper
  def create_job(
      active: true,
      stack:,
      title:,
      level: Level.where(name: "junior").first_or_create,
      link:,
      company:
  )
    job = Job.new(
        active: active,
        published_date: Date.today, # TODO: make this published date on the advert
        title: title,
        job_link: link
    )

    job.company = company
    job.level = level
    job.stack = stack

    job.save
  end
end
