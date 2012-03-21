class ParameterlessAutoGenerateTestClass < ApiQueryProvider::Base

  self.api_url = "http://example.com"
  self.api_path = "/foo/id"
  self.autogenerate = true
end