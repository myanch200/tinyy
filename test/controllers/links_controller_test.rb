require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @link = links(:one)
    @valid_link_params = { original_url: "https://example.com" }
  end

  test "should get new" do
    get new_link_path
    assert_response :success
  end

  test "should create link" do
    assert_difference("Link.count") do
      post links_path, params: { link: @valid_link_params }
    end
    assert_redirected_to link_path(Link.last)
  end

  test "should return unprocessable entity for invalid link" do
    post links_path, params: { link: { original_url: "invalid_url" } }
    assert_response :unprocessable_entity
  end

  test "should not create if normalized link exists" do
    assert_no_difference("Link.count") do
      post links_path, params: { link: { original_url: @link.original_url } }
    end
  end

  test "should show link" do
    get link_path(@link)
    assert_response :success
  end

  test "returns 404 for non-existent link" do
    refute Link.exists?(id: -1)
    get link_path(id: -1)
    assert_response :not_found
  end

  test "redirects to original URL" do
    get redirect_url(@link.slug)
    assert_response :redirect
    assert_redirected_to @link.original_url
  end

  test "returns 404 for non-existent slug" do
    refute Link.exists?(slug: "non-existent")
    get redirect_url("non-existent")
    assert_response :not_found
  end
end
