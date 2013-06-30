require 'ostruct'

module Marcellus
  def self.config
    defaults = {
      shell_options: ",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa ",
      bin_location: File.expand_path("../../../bin/marcellus", __FILE__)
    }

    @@configuration ||= OpenStruct.new(defaults)
  end
end