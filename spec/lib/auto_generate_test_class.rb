class AutoGenerateTestClass < ApiQueryProvider::Base

  self.api_url = "http://example.com"
  self.api_path = "/foo/:id/id"
  self.autogenerate = true
end