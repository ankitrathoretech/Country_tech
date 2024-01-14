class Country < ApplicationRecord
  # Define a constant array for required fields
  REQUIRED_FIELDS = [:alpha_2_code, :alpha_3_code, :currency]

  default_scope -> { where(deleted_at: nil) }

  scope :not_deleted, -> { unscoped }

  include CountryValidator

  before_validation :format_the_attributes

  def format_the_attributes
    REQUIRED_FIELDS.each do |field|
      self.send("#{field}=", send(field).upcase) if send(field).present?
    end
  end
end
