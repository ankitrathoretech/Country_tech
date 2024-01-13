class ApplicationController < ActionController::Base
  DEFAULT_PER_PAGE_RECORDS = 10
  DEFAULT_PAGE_NUMBER = 1

  private

  def render_error(status, message)
    render json: { error: message, status: status }
  end

  def page
    page_param = params[:page].to_i
    page_param <= 0 ? DEFAULT_PAGE_NUMBER : page_param
  end

  def per_page_records
    per_page_param = params[:per_page].to_i
    per_page_param <= 0 ? DEFAULT_PER_PAGE_RECORDS : per_page_param
  end

  def offset
    (page - 1) * per_page_records
  end
end
