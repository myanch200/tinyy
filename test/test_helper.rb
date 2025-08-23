require "simplecov"
require "simplecov-cobertura"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::CoberturaFormatter
])
SimpleCov.start "rails" do
  add_filter "/bin/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter %r{^/app/channels/}
  add_filter %r{^/app/jobs/}
  add_filter %r{^/app/mailers/}
  add_filter "/app/helpers/application_helper.rb"
  add_filter "/app/controllers/application_controller.rb"
  add_filter "/app/models/application_record.rb"

  enable_coverage :branch
  minimum_coverage 90

  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Views", "app/views"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
