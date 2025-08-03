# frozen_string_literal: true

module Api
  module V1
    # API controller for URL encoding and decoding operations
    class UrlsController < ApplicationController
      before_action :set_url, only: [:decode]

      def decode
        if @url
          render json: { original_url: @url.original_url }, status: :ok
        else
          render json: {
            errors: "The URL #{decode_url_params[:short_url]} was not found in our database. Please check the URL and try again."
          }, status: :not_found
        end
      end

      def encode
        @url = Url.new(encode_url_params)
        if @url.save
          render json: { short_url: @url.short_url }, status: :created
        else
          render json: { errors: @url.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_url
        @url = Url.find_by(short_url: decode_url_params[:short_url])
      end

      def encode_url_params
        params.require(:url).permit(:original_url)
      end

      def decode_url_params
        params.permit(:short_url)
      end
    end
  end
end
