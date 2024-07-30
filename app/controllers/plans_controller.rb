class PlansController < ApplicationController

  require_dependency Rails.root.join('config/initializers/open_ai.rb').to_s

  def new
    # Display the form for user input
  end

  def create
    # Fetch and sanitize parameters
    workout_params = params.slice(:workout_goal, :workout_experience_level, :workout_frequency)
    diet_params = params.slice(:diet_goal, :dietary_restrictions, :diet_calories)

    # Generate prompts
    workout_prompt = generate_workout_prompt(workout_params)
    diet_prompt = generate_diet_prompt(diet_params)

    # Fetch workout and diet plans using the OpenAI API
    @workout_plan = fetch_plan(workout_prompt)
    @diet_plan = fetch_plan(diet_prompt)

    respond_to do |format|
      format.html { render :show } # Render the show view with results
      format.turbo_stream { render turbo_stream: turbo_stream.replace('plan_results', partial: 'plans/show') }
    end
  end

  private

  def fetch_plan(prompt)
    response = OpenAIClient.generate_plan(prompt)
    response.presence || "No plan available. Please try again later."
  rescue StandardError => e
    Rails.logger.error("Error fetching plan: #{e.message}")
    "An error occurred while generating the plan. Please try again."
  end

  def generate_workout_prompt(params)
    "Generate a workout plan for a #{params[:workout_experience_level] || 'user'} who wants to #{params[:workout_goal] || 'achieve their goal'} and exercises #{params[:workout_frequency] || 'as frequently as possible'}."
  end

  def generate_diet_prompt(params)
    "Create a diet plan for someone who wants to #{params[:diet_goal] || 'achieve their dietary goal'}, prefers #{params[:dietary_restrictions] || 'no restrictions'}, and consumes approximately #{params[:diet_calories] || 'calories'} a day."
  end
end
