class Country < ApplicationRecord
  default_scope -> { where(deleted_at: nil) }

  scope :not_deleted, -> { unscoped }

  include CountryValidator
end
