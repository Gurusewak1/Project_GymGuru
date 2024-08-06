require "test_helper"

class WorkoutPlansControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get workout_plans_new_url
    assert_response :success
  end

  test "should get create" do
    get workout_plans_create_url
    assert_response :success
  end
end
