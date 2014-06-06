require "rspec"
require "documents-store"
ENV["MONGOID_ENV"] = "test"
Mongoid.load!("./spec/mongoid.yml")

RSpec.configure do |config|
  config.after(:each) do
    Mongoid.purge!
  end
end
