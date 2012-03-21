class GithubUser < ApiQueryProvider::Base
  self.api_url = "http://github.com/api/v2/json/"
  self.api_path = "user/show/:name"
  self.data_selector = Proc.new {|element| element["user"] }
  self.autogenerate = true
end