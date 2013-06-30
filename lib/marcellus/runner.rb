module Marcellus
  class Runner
    def initialize
      
      if ARGV[0] == "authorize"

        STDERR.write "user #{user} authenticated\n"

        command = ENV['SSH_ORIGINAL_COMMAND']

        abort "no command supplied in environment ($SSH_ORIGINAL_COMMAND)" unless command

        action = command.split[0]

        unless valid_actions.include? action
          abort "invalid action (valid actions: git-receive-pack, git-upload-pack)"
        end

        user = ARGV[1]

        repo_path = parse_repo_path(command)

        
        if Guard.authorize!(user, repo_path)       
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

    def parse_repo_path(command)
      # parse repo path from git command
    end
  end
end