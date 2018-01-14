
require 'faraday'
require 'faraday_middleware'
require_relative 'sign_request_middleware'
require_relative 'timestamp_request_middleware'

module BinanceApi
  module Client
    class REST
      # Public: A Module containing all of the Withdraw API endpoints
      module Withdraw_API
        # Internal: Create Lambda that returns a new Faraday client instance
        # and add it to the REST class instance variable @api. This is called
        # while a new instance of the REST class is created.
        #
        # base - The base class that is being extended into.
        def self.extended(base)
          REST.api[:withdraw] = lambda do
            Faraday.new(url: "#{BASE_URL}/wapi") do |conn|
              conn.request :url_encoded
              conn.response :json, content_type: /\bjson$/
              conn.headers['X-MBX-APIKEY'] = base.api_key
              conn.use TimestampRequestMiddleware
              conn.use SignRequestMiddleware, base.secret_key
              conn.adapter base.adapter
            end
          end
        end

        # Public: Withdraw the specified asset to the given address using
        # the authenticated account
        #
        # options - The Hash which hosts various REST query params.
        #   :asset      - The String of which asset to withdraw.
        #   :address    - The String of where to send the asset to.
        #   :addressTag - The String secondary address identifier (optional).
        #   :amount     - The String decimal value of how much to withdraw.
        #   :name       - The String description of the address
        #   :recvWindow - The Number of how long a request is valid for in
        #                 milliseconds (optional).
        #
        # Returns a Hash with the request response
        def withdraw(options)
          request :withdraw, :post, 'withdraw', options
        end

        # Public: Retrieve the deposit history for the authenticated account
        #
        # options - The Hash which hosts various REST query params.
        #   :asset      - The String of which asset to retrieve (optional).
        #   :status     - The Number of which status to retrieve (optional).
        #   :startTime  - The Timestamp of when to start the history in
        #                 milliseconds (optional).
        #   :endTime    - The Timestamp of when to end the history in
        #                 milliseconds (optional).
        #   :recvWindow - The Number of how long a request is valid for in
        #                 milliseconds (optional).
        #
        # Returns a Hash with the request response
        def deposit_history(options = {})
          request :withdraw, :get, 'depositHistory', options
        end

        # Public: Retrieve the withdraw history for the authenticated account
        #
        # options - The Hash which hosts various REST query params.
        #   :asset      - The String of which asset to retrieve (optional).
        #   :status     - The Number of which status to retrieve (optional).
        #   :startTime  - The Timestamp of when to start the history in
        #                 milliseconds (optional).
        #   :endTime    - The Timestamp of when to end the history in
        #                 milliseconds (optional).
        #   :recvWindow - The Number of how long a request is valid for in
        #                 milliseconds (optional).
        #
        # Returns a Hash with the request response
        def withdraw_history(options = {})
          request :withdraw, :get, 'withdrawHistory', options
        end

        # Public: Retrieve the deposit address for a specific asset
        #
        # options - The Hash which hosts various REST query params.
        #   :asset      - The String of which asset to retrieve (optional).
        #   :recvWindow - The Number of how long a request is valid for in
        #                 milliseconds (optional).
        #
        # Returns a Hash with the request response
        def deposit_address(options)
          request :withdraw, :get, 'depositAddress', options
        end

        # Public: Retrieve current account status
        #
        # options - The Hash which hosts various REST query params.
        #   :recvWindow - The Number of how long a request is valid for in
        #                 milliseconds (optional).
        #
        # Returns a Hash with the request response
        def account_status(options)
          request :withdraw, :get, 'accountStatus', options
        end
      end
    end
  end
end
