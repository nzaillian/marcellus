module Marcellus
  class Runner
    def initialize
      
      if ARGV[0] == "authorize"
        
        if Guard.authorize!(ARGV[1], ARGV[2])
          STDERR.write "user #{user} authenticated\n"

          command = ENV['SSH_ORIGINAL_COMMAND']

          raise "no command supplied in environment ($SSH_ORIGINAL_COMMAND)" unless command

          action = command.split[0]

          unless valid_actions.include? action
            raise "invalid action (valid actions: git-receive-pack, git-upload-pack)"
          end          

          Kernel.exec 'git', 'shell', '-c', command
        else
          STDERR.write "user #{user} unauthorized to access repo\n"
        end
      
      elsif ARGV[0] == "addkey"
        Keys.add(ARGV[1], ARGV[2])
      
      elsif ARGV[0] == "removekey"
        Keys.remove(ARGV[1], ARGV[2])

      elsif ARGV[0] == "add-repo-user"
        Repo.add_user(ARGV[1], ARGV[2])

      elsif ARGV[0] == "remove-repo-user"
        Repo.remove_user(ARGV[1], ARGV[2])
      end
    
    end
  end
end