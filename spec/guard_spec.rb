require_relative "./spec_helper"

describe Marcellus::Guard do
  before do
    @allowed_user = "allowed@example.com"
    @denied_user = "denied@example.com"

    @repo_path = "#{Marcellus::config.repo_root}/dummy_repo.git"

    FileUtils.mkdir(@repo_path)

    Marcellus::Repo.add_user(@repo_path, @allowed_user)
  end

  it "should authorize a user who has been granted access to the repo" do
    Marcellus::Guard.authorize(@allowed_user, @repo_path, :w).should == true
  end

  it "should deny a user who has not been granted access to the repo" do
    Marcellus::Guard.authorize(@denied_user, @repo_path, :w).should == false
  end

  after do
    cleanup_files
  end
end