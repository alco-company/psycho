ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |f| require f }

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include DefaultThemeLinker
    include ActiveJob::TestHelper
    setup do
      link_default_themes
      clear_enqueued_jobs
    end
  end
end

class ActiveJob::TestCase
  include ActiveJob::TestHelper
end
