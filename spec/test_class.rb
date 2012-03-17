class TestClass < ApiQueryProvider::Base

  self.api_url = "example.com"
  self.api_path = "/foo/:id/id"
end