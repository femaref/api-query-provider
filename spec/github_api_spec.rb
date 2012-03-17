require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/github_commits')

describe "github commit api" do
  it "should construct a valid object" do
    lambda do 
      GithubCommits.where(:user_id => "Femaref")
                   .where(:repository => "c2dm-rails")
                   .where(:branch => "master")
                   .execute
    end.should_not raise_error
  end
end