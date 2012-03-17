class GithubCommits < ApiQueryProvider::Base
  cattr_accessor :api_url
  cattr_accessor :api_path
  cattr_accessor :data_selector

  self.api_url = "http://github.com/api/v2/json/"
  self.api_path = "commits/list/:user_id/:repository/:branch"
  self.data_selector = Proc.new {|element| element["commits"] }

  attr_accessor :parents
  attr_accessor :author
  attr_accessor :url
  attr_accessor :id
  attr_accessor :committed_date
  attr_accessor :authored_date
  attr_accessor :message
  attr_accessor :tree
  attr_accessor :committer
end