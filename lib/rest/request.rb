# frozen_string_literal: true

module Rest
  class Request
    include HTTParty

    format :json
    default_options[:verify] = false
    headers 'Content-Type' => 'application/json'
    default_timeout 300

    ERRORS = [
      API_LIMIT_ERR_MSG = 'API quota limit error',
      NETWORK_ERR_MSG = 'Network error occurred'
    ].freeze

    def initialize(request_method, path, params = {}, options = {})
      @request_method = request_method
      @path = path
      @params = params
      @options = options
      @throttle_retries = 0
      @network_retries = 0
    end

    def perform
      response = self.class.send(@request_method, @path, @params)
      raise API_LIMIT_ERR_MSG if response.code == 429

      raw_response = response.success? ? response.parsed_response : response.body
      if response.code == 404
        raw_response += 'Record not found'
      end

      OpenStruct.new(success?: response.success?, status: response.code, response: raw_response)
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EADDRNOTAVAIL, SocketError, Timeout::Error, Errno::ETIMEDOUT
      OpenStruct.new(success?: false, status: 500, response: NETWORK_ERR_MSG)
    end
  end
end
