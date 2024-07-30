class PlansController < ApplicationController
  def new
    # Display the form for user input
  end

  def create
    open_ai_service = OpenAIService.new

    # Use user input to generate prompts
    workout_prompt = generate_workout_prompt(workout_params)
    diet_prompt = generate_diet_prompt(diet_params)

    # Fetch workout and diet plans using the OpenAI API
    @workout_plan = open_ai_service.generate_workout_plan(workout_prompt)
    @diet_plan = open_ai_service.generate_diet_plan(diet_prompt)

    # Render the results
    render :show
  end

  private

  def generate_workout_prompt(params)
    "Generate a workout plan for a #{params[:workout_experience_level]} who wants to #{params[:workout_goal]} and exercises #{params[:workout_frequency]} times a week."
  end

  def generate_diet_prompt(params)
    "Create a diet plan for someone who wants to #{params[:diet_goal]}, prefers #{params[:dietary_restrictions]}, and consumes approximately #{params[:diet_calories]} calories a day."
  end

  def workout_params
    params.permit(:workout_goal, :workout_experience_level, :workout_frequency)
  end

  def diet_params
    params.permit(:diet_goal, :dietary_restrictions, :diet_calories)
  end
end
