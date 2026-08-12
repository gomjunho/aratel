require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "application controller exists and is a base controller" do
    assert ApplicationController < ActionController::Base
  end
end
