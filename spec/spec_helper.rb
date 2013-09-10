# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
$:.unshift File.expand_path('../../lib', __FILE__)
require 'naka'
require 'webmock/rspec'
require 'factory_girl'
require 'pry'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  FactoryGirl.find_definitions
  config.include FactoryGirl::Syntax::Methods

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before do
    example.example_group.let(:mock_user) { build(:user) }
  end

  config.before { Naka.stub(:redis_prefix) { "ijn48:test" } }
  config.after { Naka::User.send(:clean) }

  config.before do
    stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/ship").
      to_return(status: 200, body: mock_file('api/ships/master.json'))
    stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/stype").
      to_return(status: 200, body: mock_file('api/master/ship_type.json'))
  end

  def mock_file(path)
    File.read File.expand_path("../support/#{path}", __FILE__)
  end
end
