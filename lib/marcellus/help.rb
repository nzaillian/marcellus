module Marcellus
  class Help
    class << self
      def print_help
        puts <<-eos
All commands:

  marcellus add-key <username> <key_string>
  marcellus remove-key <username> <key_string> 
  marcellus add-repo-user <full_path_to_repo> <username>
  marcellus remove-repo-user <full_path_to_repo> <username>
  marcellus authorize <username> <full_path_to_repo> <requested permissions ('r' or 'w')>

(note: "marcellus authorize" is not meant to be run directly in the shell but rather by SSHd as a forced command.
It expects a $SSH_ORIGINAL_COMMAND environment variable to be present. For more information
see the README at https://github.com/nzaillian/marcellus)

        eos
      end
    end
  end
end