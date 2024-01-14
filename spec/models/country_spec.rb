require 'rails_helper'

RSpec.describe Country, type: :model do
  describe "validations" do
    context "validates presence of name" do
      it "is not valid when name is nil" do
        country = build(:country, name: nil)
        expect(country).not_to be_valid
        expect(country.errors[:name]).to include("can't be blank")
      end
    end

    context "validates presence, uniqueness, and format of alpha_2_code" do
      it "is not valid when alpha_2_code is nil" do
        existing_country = create(:country)
        country = build(:country, alpha_2_code: nil, alpha_3_code: 'USA')

        expect(country).not_to be_valid
        expect(country.errors[:alpha_2_code]).to include("can't be blank")
      end

      it "is not valid when alpha_2_code is not unique" do
        existing_country = create(:country)
        country = build(:country, alpha_2_code: existing_country.alpha_2_code, alpha_3_code: 'USA')

        expect(country).not_to be_valid
        expect(country.errors[:alpha_2_code]).to include("has already been taken")
      end

      it "is not valid when alpha_2_code has an invalid format" do
        country = build(:country, alpha_2_code: "AB2", alpha_3_code: 'USA')
        expect(country).not_to be_valid
        expect(country.errors[:alpha_2_code]).to include("is invalid")
      end

      it "is valid when alpha_2_code has a valid format" do
        country = build(:country, alpha_2_code: "AB", alpha_3_code: 'USA')
        expect(country).to be_valid
      end
    end

    context "validates presence, uniqueness, and format of alpha_3_code" do
      it "is not valid when alpha_3_code is nil" do
        existing_country = create(:country)
        country = build(:country, alpha_3_code: nil, alpha_2_code: 'US')

        expect(country).not_to be_valid
        expect(country.errors[:alpha_3_code]).to include("can't be blank")
      end

      it "is not valid when alpha_3_code is not unique" do
        existing_country = create(:country)
        country = build(:country, alpha_3_code: existing_country.alpha_3_code, alpha_2_code: 'US')

        expect(country).not_to be_valid
        expect(country.errors[:alpha_3_code]).to include("has already been taken")
      end

      it "is not valid when alpha_3_code has an invalid format" do
        country = build(:country, alpha_3_code: "AB1", alpha_2_code: 'US')
        expect(country).not_to be_valid
        expect(country.errors[:alpha_3_code]).to include("is invalid")
      end

      it "is valid when alpha_3_code has a valid format" do
        country = build(:country, alpha_3_code: "ABC", alpha_2_code: 'US')
        expect(country).to be_valid
      end
    end

    context "validates presence and format of currency" do
      it "is not valid when currency is nil" do
        country = build(:country, currency: nil)
        expect(country).not_to be_valid
        expect(country.errors[:currency]).to include("can't be blank")
      end

      it "is valid when currency has a valid format" do
        country = build(:country, currency: "USD")
        expect(country).to be_valid
      end

      it "is not valid when currency has an invalid format" do
        country = build(:country, currency: "US")
        expect(country).not_to be_valid
        expect(country.errors[:currency]).to include("is the wrong length (should be 3 characters)")
      end
    end
  end

  describe "scopes" do
    it "includes only undeleted records by default" do
      undeleted_country = create(:country, alpha_2_code: 'US', alpha_3_code: 'USA')
      deleted_country = create(:country, deleted_at: Time.now)

      expect(Country.count).to eq(1)
      expect(Country.first).to eq(undeleted_country)
    end
  end

  describe "callbacks" do
    context '#format_the_attributes' do
      it "converts alpha_2_code, alpha_3_code, and currency to uppercase" do
        country = build(:country, alpha_2_code: "ab", alpha_3_code: "abc", currency: "usd")

        # Before validation, the attributes should be in lowercase
        expect(country.alpha_2_code).to eq("ab")
        expect(country.alpha_3_code).to eq("abc")
        expect(country.currency).to eq("usd")

        # Trigger validation
        country.valid?

        # After validation, the attributes should be converted to uppercase
        expect(country.alpha_2_code).to eq("AB")
        expect(country.alpha_3_code).to eq("ABC")
        expect(country.currency).to eq("USD")
      end

      it "leaves attributes as they are if they are already in uppercase" do
        country = build(:country, alpha_2_code: "AB", alpha_3_code: "ABC", currency: "USD")

        # Before validation, the attributes should be in uppercase
        expect(country.alpha_2_code).to eq("AB")
        expect(country.alpha_3_code).to eq("ABC")
        expect(country.currency).to eq("USD")

        # Trigger validation
        country.valid?

        # The attributes should remain in uppercase
        expect(country.alpha_2_code).to eq("AB")
        expect(country.alpha_3_code).to eq("ABC")
        expect(country.currency).to eq("USD")
      end

      it "leaves attributes as they are if they are nil" do
        country = build(:country, alpha_2_code: nil, alpha_3_code: nil, currency: nil)

        # Before validation, the attributes should be nil
        expect(country.alpha_2_code).to be_nil
        expect(country.alpha_3_code).to be_nil
        expect(country.currency).to be_nil

        # Trigger validation
        country.valid?

        # The attributes should remain nil
        expect(country.alpha_2_code).to be_nil
        expect(country.alpha_3_code).to be_nil
        expect(country.currency).to be_nil
      end
    end
  end
end
