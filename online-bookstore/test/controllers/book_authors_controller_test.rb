require 'test_helper'

class BookAuthorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_author = book_authors(:one)
  end

  test "should get index" do
    get book_authors_url
    assert_response :success
  end

  test "should get new" do
    get new_book_author_url
    assert_response :success
  end

  test "should create book_author" do
    assert_difference('BookAuthor.count') do
      post book_authors_url, params: { book_author: { AUTHOR_id: @book_author.AUTHOR_id, BOOK_ISBN: @book_author.BOOK_ISBN } }
    end

    assert_redirected_to book_author_url(BookAuthor.last)
  end

  test "should show book_author" do
    get book_author_url(@book_author)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_author_url(@book_author)
    assert_response :success
  end

  test "should update book_author" do
    patch book_author_url(@book_author), params: { book_author: { AUTHOR_id: @book_author.AUTHOR_id, BOOK_ISBN: @book_author.BOOK_ISBN } }
    assert_redirected_to book_author_url(@book_author)
  end

  test "should destroy book_author" do
    assert_difference('BookAuthor.count', -1) do
      delete book_author_url(@book_author)
    end

    assert_redirected_to book_authors_url
  end
end
