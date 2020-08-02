# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Stacks
stacks = ["backend", "frontend", "fullstack"]
stacks.each do |stack|
  Stack.new(name: stack).save
end

# Levels
levels = ["junior", "mid", "senior", "lead", "staff"]
levels.each do |level|
  Level.new(name: level).save
end

# Technologies
technologies = ["ruby", "javascript", "python", "java", "scala"]
technologies.each do |technology|
  Technology.new(name: technology).save
end

# Companies
companies = ["test company1", "test company2"]
companies.each do |company|
  Company.new(name: company).save
end