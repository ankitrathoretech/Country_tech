module CountryValidator
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true

    validates :alpha_code_2, presence: true, uniqueness: true, length: { is: 2 }, format: { with: /\A[A-Z]+\z/ }

    validates :alpha_code_3, presence: true, uniqueness: true, length: { is: 3 }, format: { with: /\A[A-Z]+\z/ }

    validates :currency, presence: true, length: { is: 3 }, format: { with: /\A[A-Z]+\z/ }
  end
end
