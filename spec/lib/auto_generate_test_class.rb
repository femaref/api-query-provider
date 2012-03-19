class AutoGenerateTestClass < ApiQueryProvider::Base

  self.api_url = "example.com"
  self.api_path = "/foo/:id/id"
  self.autogenerate = true
end