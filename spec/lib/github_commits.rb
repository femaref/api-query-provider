class GithubCommits < ApiQueryProvider::Base
  self.api_url = "http://github.com/api/v2/json/"
  self.api_path = "commits/list/:user_id/:repository/:branch"
  self.data_selector = Proc.new {|element| element["commits"] }
  self.autogenerate = true
end