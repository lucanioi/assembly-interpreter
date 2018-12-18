require 'rspec/collection_matchers'
require 'pry'

$LOAD_PATH.unshift('lib')

require 'assembly'
require 'helpers/extensions'

module Assembly
  module SpecHelper
    extend self

    def configure_rspec
      RSpec.configure do |config|
        config.include Extensions
      end
    end
  end
end

Assembly::SpecHelper.configure_rspec