class OptionalWhereTestClass < ApiQueryProvider::Base

  self.api_url = "example.com"
  self.api_path = "/foo/?:where"
end