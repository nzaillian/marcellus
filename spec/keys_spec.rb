require_relative "./spec_helper"

describe Marcellus::Keys do
  before do
    @key_file_path = Marcellus::Keys.key_file_path
    @authorized_keys_path = Marcellus::Keys.authorized_keys_path
    @user = "joeuser@email.com"
    @key = "ssh-rsa auserkey"
  end

  it "should successfully persist a user and key to the key file" do
    Marcellus::Keys.add(@user, @key)
    serialized = YAML::load(File.read(@key_file_path))
    serialized.keys.should include(@user)
    serialized[@user].should include(@key)
  end
end