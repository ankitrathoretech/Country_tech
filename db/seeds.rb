# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

# Sample data for countries
if Country.unscoped.count > 0
  Country.unscoped.destroy_all
end

# Sample data for countries
countries_data = [
  { name: 'United States', alpha_2_code: 'US', alpha_3_code: 'USA', currency: 'USD' },
  { name: 'Canada', alpha_2_code: 'CA', alpha_3_code: 'CAN', currency: 'CAD' },
  { name: 'United Kingdom', alpha_2_code: 'GB', alpha_3_code: 'GBR', currency: 'GBP' },
  { name: 'Australia', alpha_2_code: 'AU', alpha_3_code: 'AUS', currency: 'AUD' },
  { name: 'Germany', alpha_2_code: 'DE', alpha_3_code: 'DEU', currency: 'EUR' },
  { name: 'France', alpha_2_code: 'FR', alpha_3_code: 'FRA', currency: 'EUR' },
  { name: 'Japan', alpha_2_code: 'JP', alpha_3_code: 'JPN', currency: 'JPY' },
  { name: 'Brazil', alpha_2_code: 'BR', alpha_3_code: 'BRA', currency: 'BRL' },
  { name: 'India', alpha_2_code: 'IN', alpha_3_code: 'IND', currency: 'INR' },
  { name: 'China', alpha_2_code: 'CN', alpha_3_code: 'CHN', currency: 'CNY' },
  # Add more sample data entries here...
]


# Create country records from the sample data
countries_data.each do |country|
  Country.create(
    name: country[:name],
    alpha_2_code: country[:alpha_2_code],
    alpha_3_code: country[:alpha_3_code],
    currency: country[:currency]
  )
end

