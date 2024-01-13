FactoryBot.define do
  factory :country do
    name { 'India' }
    alpha_2_code { 'IN' }
    alpha_3_code { 'IND' }
    currency { 'INR' }
  end
end
