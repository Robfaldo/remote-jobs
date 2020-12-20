# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

i = 0
10.times do
  job = Job.new(
    title: "Test title #{i}",
    job_link: "www.google.com",
    location: "London",
    description: "Test description #{i}",
    source: ["indeed", "stackoverflow", "google"].sample,
    status: "scraped",
    company: "Test company #{i}"
  )

  job.source_id = "Test source id #{i}" if [1, 2].sample.even?
  job.job_board = "Test job board #{i}" if [1, 2].sample.even?

  job.save!
  i += 1
end
