require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "creating a Order" do
    visit orders_url
    click_on "New Order"

    fill_in "Book isbn", with: @order.BOOK_ISBN
    check "Confirmed" if @order.confirmed
    fill_in "Date submitted", with: @order.date_submitted
    fill_in "Estimated arrival date", with: @order.estimated_arrival_date
    fill_in "Quantity", with: @order.quantity
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    fill_in "Book isbn", with: @order.BOOK_ISBN
    check "Confirmed" if @order.confirmed
    fill_in "Date submitted", with: @order.date_submitted
    fill_in "Estimated arrival date", with: @order.estimated_arrival_date
    fill_in "Quantity", with: @order.quantity
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "destroying a Order" do
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end
end
