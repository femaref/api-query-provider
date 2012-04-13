class AutoGenerateTestClass < ApiQueryProvider::Base

  api_for  :api_url => "http://example.com",
           :api_path => "/foo/:id/id"
           
  self.autogenerate = true
end