require 'test_helper'

class GrievancesControllerTest < ActionController::TestCase
  setup do
    @grievance = grievances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grievances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grievance" do
    assert_difference('Grievance.count') do
      post :create, grievance: { city_id: @grievance.city_id, cop_id: @grievance.cop_id, date_incident: @grievance.date_incident, description: @grievance.description, is_new: @grievance.is_new, is_revision: @grievance.is_revision, publish_user_age: @grievance.publish_user_age, publish_user_race: @grievance.publish_user_race, revision_id: @grievance.revision_id, state_id: @grievance.state_id, user_id: @grievance.user_id, visible: @grievance.visible }
    end

    assert_redirected_to grievance_path(assigns(:grievance))
  end

  test "should show grievance" do
    get :show, id: @grievance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grievance
    assert_response :success
  end

  test "should update grievance" do
    patch :update, id: @grievance, grievance: { city_id: @grievance.city_id, cop_id: @grievance.cop_id, date_incident: @grievance.date_incident, description: @grievance.description, is_new: @grievance.is_new, is_revision: @grievance.is_revision, publish_user_age: @grievance.publish_user_age, publish_user_race: @grievance.publish_user_race, revision_id: @grievance.revision_id, state_id: @grievance.state_id, user_id: @grievance.user_id, visible: @grievance.visible }
    assert_redirected_to grievance_path(assigns(:grievance))
  end

  test "should destroy grievance" do
    assert_difference('Grievance.count', -1) do
      delete :destroy, id: @grievance
    end

    assert_redirected_to grievances_path
  end
end
