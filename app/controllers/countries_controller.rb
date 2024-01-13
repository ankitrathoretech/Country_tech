class CountriesController < ApplicationController
  before_action :get_country, only: [:destroy]

  def index
    @countries = Country.all

    render json: { countries: @countries, total_count: @countries.count }
  end

  def search
    if filter_keys_present?
      @countries = Country.where(filtered_params)

      render json: { countries: @countries, total_count: @countries.count }
    else
      render_missing_filter_message
    end
  end

  def destroy
    if @country
      if @country.update_attributes(deleted_at: Time.current)
        render json: { message: 'Successfully deleted the country.' }
      else
        render json: { error: @country.errors.full_messages.to_sentence, status: 422 }
      end
    else
      render_missing_country_message
    end
  end

  private

  def get_country
    @country = Country.find_by(id: params[:id])
  end

  def filter_keys_present?
    keys_to_check = [:alpha_2_code, :alpha_3_code, :currency]
    keys_to_check.any? { |key| filtered_params.key?(key) }
  end

  def filtered_params
    params.transform_values(&:presence).compact
  end

  def render_missing_filter_message
    render json: { message: "Atleast one filter is must alpha_code_2/alpha_code_3/curreny" }, status: 400
  end

  def render_missing_country_message
    render json: { message: "Country not found for ID #{params[:id]}" }, status: 404
  end
end
