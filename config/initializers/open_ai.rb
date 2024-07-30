# config/initializers/open_ai.rb
require 'net/http'
require 'json'
require 'uri'

module OpenAIClient
  API_KEY = ENV['OPENAI_API_KEY']
  BASE_URI = 'https://api.openai.com/v1/completions'.freeze

  def self.generate_plan(prompt_text)
    uri = URI(BASE_URI)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, {
      'Authorization' => "Bearer #{API_KEY}",
      'Content-Type' => 'application/json'
    })

    request.body = {
      model: 'text-davinci-003',
      prompt: prompt_text,
      max_tokens: 150
    }.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      response_body = JSON.parse(response.body)
      response_body['choices'].first['text'].strip
    else
      "Error: #{response.code} - #{response.message}, Details: #{response.body}"
    end
  end
end
