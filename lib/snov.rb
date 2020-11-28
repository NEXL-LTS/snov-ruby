require "snov/version"

module Snov
  class Error < StandardError; end

  def self.client
    if !use_fake?
      Client.new(client_id: ENV['SNOV_USER_ID'], client_secret: ENV['SNOV_SECRET'])
    else
      FakeClient.new
    end
  end

  def self.use_fake?
    ENV['SNOV_USE_FAKE'].present? || (!ENV.key?('SNOV_USER_ID') && !ENV.key?('SNOV_SECRET'))
  end
end

require 'active_model'
require 'snov/client'
require 'snov/fake_client'
require 'snov/get_all_prospects_from_list'
require 'snov/get_prospect_list'
require 'snov/get_user_lists'
