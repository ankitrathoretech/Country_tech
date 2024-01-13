class CountriesController < ApplicationController
  before_action :load_country, only: [:destroy]

  def index
    countries = Country.all.limit(per_page_records).offset(offset)

    render json: { countries: countries, total_count: total_country_count }
  end

  def search
    if filter_params[:alpha_2_code].present? || filter_params[:alpha_3_code].present?
      # If either alpha_2_code or alpha_3_code is present, return a single country
      render_single_country
    elsif filter_params[:currency].present?
      # If currency is present, return a collection of countries with the same currency
      render_filtered_countries
    else
      render_missing_filter_message
    end
  end

  def destroy
    if @country.update(deleted_at: Time.current)
      render json: { message: 'Successfully deleted the country.' }
    else
      render_error(422, @country.errors.full_messages.to_sentence)
    end
  end

  private

  def render_single_country
    country = Country.find_by(filter_params)
    if country
      render json: { country: country }
    else
      render_error(404, "Country not found for given filter parameters")
    end
  end

  def render_filtered_countries
    countries = Country.where(filter_params).limit(per_page_records).offset(offset)
    render json: { countries: countries, total_count: total_count }
  end

  def load_country
    @country = Country.find_by(id: params[:id])

    render_missing_country_message unless @country
  end

  def filter_params_present?
    filter_params.present?
  end

  def filter_params
    params.slice(:alpha_2_code, :alpha_3_code, :currency).compact.presence
  end

  def total_country_count
    Country.count
  end

  def render_missing_filter_message
    render_error(400, "At least one filter is required: alpha_2_code, alpha_3_code, or currency")
  end

  def render_missing_country_message
    render_error(404, "Country not found for ID #{params[:id]}")
  end
end
