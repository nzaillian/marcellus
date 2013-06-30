require "marcellus"

spec_root = File.expand_path("..", __FILE__)

::Marcellus::config.authorized_keys_path = "#{spec_root}/data/test_authorized_keys"
::Marcellus::config.repo_root = "#{spec_root}/data/test_repo_root"
::Marcellus::config.key_storage_location = "#{spec_root}/data/test_user_keys.yml"