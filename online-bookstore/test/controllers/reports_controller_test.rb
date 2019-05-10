require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get sales" do
    get reports_sales_url
    assert_response :success
  end

  test "should get top_customers" do
    get reports_top_customers_url
    assert_response :success
  end

  test "should get best_selling" do
    get reports_best_selling_url
    assert_response :success
  end

end
