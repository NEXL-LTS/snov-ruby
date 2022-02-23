require "snov/version"
require 'active_support/core_ext/module/attribute_accessors'

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

  mattr_accessor :token_storage
end

require 'active_model'
require 'snov/client'
require 'snov/in_memory_token_storage'
require 'snov/redis_token_storage'
require 'snov/fake_client'
require 'snov/get_profile_by_email'
require 'snov/get_all_prospects_from_list'
require 'snov/get_prospects_by_email'
require 'snov/get_prospect_list'
require 'snov/get_user_lists'
require 'snov/get_emails_by_social_url'
require 'snov/get_emails_from_name'
require 'snov/add_names_to_find_emails'
require 'snov/domain_search'
