class Link < ApplicationRecord
  before_validation :normalize_url
  before_validation :assign_unique_slug, on: :create

  validates :original_url, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validate  :url_must_be_httpish


  SLUG_LENGTH = 8

  def self.normalize_url_str(url)
    return "" if url.blank?
    u = url.strip
    u = "https://#{u}" unless u[%r{\A[a-z][a-z0-9+\-.]*://}i]
    u
  end

  private

  def normalize_url
    return if original_url.blank?

    self.original_url = self.class.normalize_url_str(original_url)
  end

  def url_must_be_httpish
    return if original_url.blank?

    uri = URI.parse(original_url) rescue nil

    unless uri&.host && %w[http https].include?(uri.scheme) && uri.host.match?(/\./)
      errors.add(:original_url, "must be a valid http/https URL")
    end
  end

  def assign_unique_slug
    self.slug = generate_slug while slug.blank? || self.class.exists?(slug: slug)
  end

  def generate_slug
     SecureRandom.urlsafe_base64(SLUG_LENGTH)
  end
end
