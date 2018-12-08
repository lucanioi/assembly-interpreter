require 'rspec/collection_matchers'

$LOAD_PATH.unshift('lib')

require 'assembly'

module Assembly
  module SpecHelper
    extend self

    def configure_rspec
      RSpec.configure do |config|
        # ...
      end
    end
  end
end

Assembly::SpecHelper.configure_rspec