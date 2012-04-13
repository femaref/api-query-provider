class OptionalWhereTestClass < ApiQueryProvider::Base

  api_for :api_url => "example.com",
          :api_path => "/foo/?:where"
end