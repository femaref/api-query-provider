class TestClass < ApiQueryProvider::Base

  self.api_url = "http://example.com"
  self.api_path = "/foo/:id/id"
end