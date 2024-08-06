# app/controllers/workout_plans_controller.rb
class WorkoutPlansController < ApplicationController
  def create
    prompt = build_prompt(params[:age], params[:gender], params[:fitness_level], params[:goal])
    service = OpenAIService.new
    response = service.generate_workout_plan(prompt)
    
    if response['error']
      flash[:error] = response['error']
      render :new
    else
      # Handle the successful response here
    end
  end

  private

  def build_prompt(age, gender, fitness_level, goal)
    "Generate a workout plan for a #{age}-year-old #{gender} with #{fitness_level} fitness level who wants to focus on #{goal}."
  end
end
