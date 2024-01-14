require 'rails_helper'

RSpec.describe CountriesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns JSON with countries and total_count' do
      country = create(:country)
      get :index
      expect(response).to be_successful
      json_response = parse_json(response.body)

      expect(json_response[:countries].count).to eq(1)
      expect(json_response[:total_count]).to eq(1)
    end

    it 'paginates results when per_page param is provided' do
      # Create more than one country
      create_list(:country, 3)

      # Set the per_page param to 2 to limit results per page
      get :index, params: { per_page: 2, page: 1 }

      expect(response).to be_successful
      json_response = parse_json(response.body)

      expect(json_response[:countries].count).to eq(2)
      expect(json_response[:total_count]).to eq(3)

      # You can also test for the second page
      get :index, params: { per_page: 2, page: 2 }

      expect(response).to be_successful
      json_response = parse_json(response.body)
      expect(json_response[:countries].count).to eq(1)
      expect(json_response[:total_count]).to eq(3)
    end
  end

  describe 'GET #search' do
    context 'when searching by alpha_2_code' do
      it 'returns a single country if found' do
        country = create(:country)
        get :search, params: { alpha_2_code: country.alpha_2_code }
        expect(response).to be_successful
        json_response = parse_json(response.body)
        expect(json_response[:country][:alpha_2_code]).to eq(country.alpha_2_code)
      end

      it 'returns a 404 error if country not found' do
        get :search, params: { alpha_2_code: 'XX' } # Non-existent code

        json_response = parse_json(response.body)

        expect(json_response[:status]).to eq(404)
        expect(json_response[:error]).to eq("Country not found for given filter parameters")
      end
    end

    context 'when searching by alpha_3_code' do
      it 'returns a single country if found' do
        country = create(:country)
        get :search, params: { alpha_3_code: country.alpha_3_code }
        expect(response).to be_successful
        json_response = parse_json(response.body)
        expect(json_response[:country][:alpha_3_code]).to eq(country.alpha_3_code)
      end

      it 'returns a 404 error if country not found' do
        get :search, params: { alpha_3_code: 'XXA' } # Non-existent code

        json_response = parse_json(response.body)

        expect(json_response[:status]).to eq(404)
        expect(json_response[:error]).to eq("Country not found for given filter parameters")
      end
    end

    context 'when searching by currency' do
      it 'returns a collection of countries with the same currency' do
        currency = 'USD'
        country1 = create(:country, currency: currency)
        country2 = create(:country, currency: currency)

        get :search, params: { currency: currency }

        expect(response).to be_successful
        json_response = parse_json(response.body)
        expect(json_response[:countries].count).to eq(2)
      end

      it 'returns an empty collection if no countries have the same currency' do
        get :search, params: { currency: 'XXX' } # Non-existent currency
        expect(response).to be_successful
        json_response = parse_json(response.body)
        expect(json_response[:countries].count).to eq(0)
      end

      it 'paginates results when per_page param is provided' do
        currency = 'USD'
        create_list(:country, 5, currency: currency)

        # Set the per_page param to 2 to limit results per page
        get :search, params: { currency: currency, per_page: 2, page: 1 }

        expect(response).to be_successful
        json_response = parse_json(response.body)
        expect(json_response[:countries].count).to eq(2)
        expect(json_response[:total_count]).to eq(5)

        # You can also test for the second page
        get :search, params: { currency: currency, per_page: 2, page: 2 }

        expect(response).to be_successful
        json_response = parse_json(response.body)
        expect(json_response[:countries].count).to eq(2)
      end
    end

    context 'when missing or invalid filters' do
      it 'returns a 400 error with a missing filter message' do
        get :search

        json_response = parse_json(response.body)

        expect(json_response[:status]).to eq(400)
        expect(json_response[:error]).to eq("At least one filter is required: alpha_2_code, alpha_3_code, or currency")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested country' do
      country = create(:country)
      expect {
        delete :destroy, params: { id: country.to_param }
      }.to change(Country, :count).by(-1)
    end

    it 'returns a success response' do
      country = create(:country)
      delete :destroy, params: { id: country.to_param }
      expect(response).to be_successful
    end

    it 'returns an error response when country not found' do
      delete :destroy, params: { id: 'nonexistent_id' }
      json_response = parse_json(response.body)

      expect(json_response[:status]).to eq(404)
      expect(json_response[:error]).to eq("Country not found for ID nonexistent_id")
    end
  end

  def parse_json(response_body)
    JSON.parse(response_body).with_indifferent_access
  end
end
