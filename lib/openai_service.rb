# lib/openai_service.rb
require 'openai'

class OpenAIService
  def initialize
    @client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  end

  def generate_workout_plan(prompt)
    response = @client.completions(
      parameters: {
        model: 'text-davinci-003',
        prompt: prompt,
        max_tokens: 150
      }
    )
    response['choices'].first['text']
  rescue StandardError => e
    Rails.logger.error("API request failed: #{e.message}")
    { error: e.message }
  end
end
