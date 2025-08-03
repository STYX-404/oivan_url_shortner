# frozen_string_literal: true

# Controller for handling URL redirects
class RedirectsController < ApplicationController
  before_action :set_url, only: %i[show]
  def show
    if @url
      redirect_to @url.original_url, allow_other_host: true
    else
      head :not_found
    end
  end

  private

  def set_url
    uniq_key = params[:uniq_key]
    @url = Url.find_by(short_url: "#{Rails.application.credentials[:domain_url]}/#{uniq_key}")
  end
end
