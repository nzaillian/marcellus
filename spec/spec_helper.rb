require "marcellus"

spec_root = File.expand_path("..", __FILE__)

::Marcellus::config.authorized_keys_path = "#{spec_root}/data/test_authorized_keys"
::Marcellus::config.repo_root = "#{spec_root}/data/test_repo_root"
::Marcellus::config.key_storage_location = "#{spec_root}/data/test_user_keys.yml"

if ! File.exists?("#{spec_root}/data/test_repo_root")
  FileUtils.mkdir("#{spec_root}/data/test_repo_root")
end

def cleanup_files
  config = ::Marcellus::config

  [config.authorized_keys_path, config.key_storage_location].each do |file_path|
    FileUtils.rm_rf(file_path)
  end

  Dir["#{config.repo_root}/**"].each do |dir|
    FileUtils.rm_rf(dir)
  end
end