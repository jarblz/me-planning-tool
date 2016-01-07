# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.all.each do |u|
  u.destroy!
end

GlobalIndicator.all.each do |g|
  g.destroy!
end

User.create!(
  email: "admin@standardco.de",
  password: "password",
  admin: true
)
User.create!(
  email: "user@standardco.de",
  password: "password"
)

GlobalIndicator.create!(
  primary_indicator_name: "Primary Indicator",
  secondary_indicator_name: "Secondary Indicator"
)

Disease.create!(
  name: "HIV"
)
Disease.create!(
  name: "Trachoma"
)
Disease.create!(
  name: "Malaria"
)

Rake::Task['import_countries_from_fusion'].invoke
