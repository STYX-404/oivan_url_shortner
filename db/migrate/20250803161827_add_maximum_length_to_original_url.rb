# frozen_string_literal: true

class AddMaximumLengthToOriginalUrl < ActiveRecord::Migration[7.1]
  def change
    change_column :urls, :original_url, :string, limit: 255
  end
end
