class Country < ApplicationRecord
  default_scope -> { where(deleted_at: nil) }

  include CountryValidator

end
