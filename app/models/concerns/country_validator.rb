module CountryValidator
  extend ActiveSupport::Concern

  ONLY_ALPHABATES_REGEX = /\A[A-Z]+\z/

  included do
    validates :name, presence: true

    validates :alpha_2_code, presence: true, uniqueness: true, length: { is: 2 }, format: { with: ONLY_ALPHABATES_REGEX }

    validates :alpha_3_code, presence: true, uniqueness: true, length: { is: 3 }, format: { with: ONLY_ALPHABATES_REGEX }

    validates :currency, presence: true, length: { is: 3 }, format: { with: ONLY_ALPHABATES_REGEX }
  end
end
