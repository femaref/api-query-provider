class GithubUser < ApiQueryProvider::Base
  api_for :api_url => "http://github.com/api/v2/json/",
          :api_path => "user/show/:name"
  self.data_selector = Proc.new {|element| element["user"] }
  self.autogenerate = true
end