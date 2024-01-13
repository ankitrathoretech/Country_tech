FactoryBot.define do
  sequence :alpha_2_code do |n|
    ('AA'..'ZZ').to_a.sample
  end

  sequence :alpha_3_code do |n|
    ('AAA'..'ZZZ').to_a.sample
  end

  factory :country do
    name { 'India' }
    alpha_2_code { generate(:alpha_2_code) }
    alpha_3_code { generate(:alpha_3_code) }
    currency { 'INR' }
  end
end
