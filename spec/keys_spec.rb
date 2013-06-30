require_relative "./spec_helper"

describe Marcellus::Keys do
  before do
    @key_file_path = Marcellus::Keys.key_file_path
    @authorized_keys_path = Marcellus::Keys.authorized_keys_path
    @user = "joeuser@email.com"
    @key = "ssh-rsa auserkey"


    @user2 = "joeuser2@email.com"
    @key2 = "ssh-rsa aseconduserkey"
    @key3 = "ssh-rsa athirduserkey"
  end

  it "should successfully persist a user and key to the key storage file" do
    # add a key for user
    Marcellus::Keys.add(@user, @key)
    
    serialized = YAML::load(File.read(@key_file_path))
    serialized.keys.should include(@user)

    # confirm key now present in key file
    serialized[@user].should include(@key)
  end

  it "should successfully handle removal of user keys from the key storage file" do
    # add 2 keys for user 2
    Marcellus::Keys.add(@user2, @key2)
    Marcellus::Keys.add(@user2, @key3)

    serialized = YAML::load(File.read(@key_file_path))
    serialized[@user2].should include(@key2, @key3)

    # remove 1
    Marcellus::Keys.remove(@user2, @key2)

    serialized = YAML::load(File.read(@key_file_path))
    serialized[@user2].should_not include(@key2)    

    # remove another
    Marcellus::Keys.remove(@user2, @key3)

    serialized = YAML::load(File.read(@key_file_path))

    # confirm that user was entirely removed from key 
    # storage file (since he has no keys)
    serialized.keys.should_not include(@user2)        
  end

  after do
    cleanup_files
  end
end