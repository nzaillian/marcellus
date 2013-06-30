require_relative "./spec_helper"

describe Marcellus::Repo do
  before do
    # make a dummy repo
    @repo_path = "#{Marcellus::config.repo_root}/dummy_repo.git"
    @user = "joe@user.com"
    FileUtils.mkdir(@repo_path)
  end

  it "should successfully add a user to a repo's \".mc-access\" file" do
    Marcellus::Repo.add_user(@repo_path, @user)

    repo_users = Marcellus::Repo.users(@repo_path)

    repo_users.keys.should include(@user)
  end

  it "should successfully remove a user from a repo's \".mc-access\" file" do
    Marcellus::Repo.add_user(@repo_path, @user)
    
    repo_users = Marcellus::Repo.users(@repo_path)

    repo_users.keys.should include(@user)

    Marcellus::Repo.remove_user(@repo_path, @user)

    repo_users = Marcellus::Repo.users(@repo_path)

    repo_users.keys.should_not include(@user)
  end

  after do
    cleanup_files
  end
end