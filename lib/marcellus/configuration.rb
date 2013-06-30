require 'ostruct'

module Marcellus
  def self.config
    root_dir = File.expand_path("../../..", __FILE__)

    defaults = {
      shell_options:           ",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ",
      bin_location:            "#{root_dir}/bin/marcellus",
      key_storage_location:    "#{root_dir}/data/user_keys.yml",
      authorized_keys_path:    "#{root_dir}/data/test_authorized_keys",
      repo_root:               "#{root_dir}/data/repos"
    }

    @@configuration ||= OpenStruct.new(defaults)
  end
end

# if you want to modify marcellus' default configuration (modify repo root path, for
# example) add configuration details to  ~/.marcellus-config

config_file_path = File.expand_path("~/.marcellus-rc")

if File.exists?(config_file_path)
  eval File.read(config_file_path)
end