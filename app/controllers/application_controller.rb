class ApplicationController < ActionController::Base
  DEFAULT_PER_PAGE_RECORDS = 10
  DEFAULT_PAGE_NUMBER = 1

  private

  def render_error(status, message)
    render json: { error: message, status: status }
  end

  def page
    params[:page] || DEFAULT_PAGE_NUMBER
  end

  def per_page_records
    params[:per_page] || DEFAULT_PER_PAGE_RECORDS
  end
end
