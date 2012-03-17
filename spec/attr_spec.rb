require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/test_class')
require File.expand_path(File.dirname(__FILE__) + '/github_commits')

describe "ApiQueryProvider::Provider" do
  it "should not replace api_url and api_path of two classes" do
    TestClass.api_url.should == "example.com"
    TestClass.api_path.should == "/foo/:id/id"
    
    GithubCommits.api_url.should == "http://github.com/api/v2/json/"
    GithubCommits.api_path.should == "commits/list/:user_id/:repository/:branch"
  end
end