class TestClass < ApiQueryProvider::Base
  cattr_accessor :api_url
  cattr_accessor :api_path
  cattr_accessor :data_selector

  self.api_url = "example.com"
  self.api_path = "/foo/:id/id"
  self.data_selector = Proc.new {|element| element }
end