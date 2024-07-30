require 'openai'

class OpenAIService
  def initialize
    @client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  end

  def generate_diet_plan(preferences)
    prompt = "Create a personalized diet plan based on the following preferences: #{preferences}"
    response = @client.completions.create(
      model: 'gpt-4',
      prompt: prompt,
      max_tokens: 150
    )
    response.choices.first.text.strip
  end

  def generate_workout_plan(preferences)
    prompt = "Create a personalized workout plan based on the following preferences: #{preferences}"
    response = @client.completions.create(
      model: 'gpt-4',
      prompt: prompt,
      max_tokens: 150
    )
    response.choices.first.text.strip
  end
end
