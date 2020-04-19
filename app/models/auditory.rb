class Auditory < ActiveRecord::Base
  def self.notify_slack(text)
    return if %w[development test].include? Rails.env

    payload  = { text: text }
    response = slack_connection.post '/services/T011CJLKV8F/B011CJLPK71/WGneqoDPye78a1C8CHDvvWjH', payload

    return if response.status == 200

    Rails.logger.error("[!] Unexpected error while notifying slacks. Payload: #{text}. Response: #{response}")
  end

  private

  def slack_connection
    @connection ||= Faraday.new(url: 'https://hooks.slack.com') do |builder|
      builder.request :json
    end
    @connection
  end
end
