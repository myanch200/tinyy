require "test_helper"

class LinkTest < ActiveSupport::TestCase
  setup do
    @link = Link.new(original_url: "https://example.com")
  end

  test "valid link" do
    assert @link.valid?
  end

  test "invalid without original_url" do
    @link.original_url = nil
    refute @link.valid?
  end

  test "normalize original_url before saving" do
    @link.original_url = "www.example.com"
    @link.save
    assert_equal "https://www.example.com", @link.reload.original_url
  end

  test "url checked for uniqueness" do
    duplicate_link = @link.dup
    @link.save

    assert_raises(ActiveRecord::RecordNotUnique) do
      duplicate_link.save!
    end
  end

  test "slug is generated on create" do
    @link.save
    assert @link.slug.present?
  end

  test "returns error when original_url is invalid" do
    @link.original_url = "invalid_url"
    refute @link.valid?
    assert @link.errors[:original_url].any?
  end
end
