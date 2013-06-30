require 'ostruct'

module Marcellus
  def self.config
    root_dir = File.expand_path("../../..", __FILE__)

    defaults = {
      shell_options:           ",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ",
      bin_location:            "#{root_dir}/bin/marcellus",
      key_storage_location:    "#{root_dir}/data/user_keys.yml",
      authorized_keys_path:    "#{root_dir}/data/test_authorized_keys"
    }

    @@configuration ||= OpenStruct.new(defaults)
  end
end