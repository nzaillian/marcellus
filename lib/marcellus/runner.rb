module Marcellus
  class Runner
    def initialize
      
      if ARGV[0] == "authorize"
        authorize_and_run_command
      
      elsif ARGV[0] == "add-key"
        Keys.add(ARGV[1], ARGV[2])
      
      elsif ARGV[0] == "remove-key"
        Keys.remove(ARGV[1], ARGV[2])

      elsif ARGV[0] == "add-repo-user"
        Repo.add_user(ARGV[1], ARGV[2])

      elsif ARGV[0] == "remove-repo-user"
        Repo.remove_user(ARGV[1], ARGV[2])
      end

    end

    private

    def authorize_and_run_command

      command = ENV['SSH_ORIGINAL_COMMAND']

      abort "no command supplied in environment ($SSH_ORIGINAL_COMMAND)" unless command

      action = command.split[0]

      unless valid_actions.include? action
        abort "invalid action (valid actions: git-receive-pack, git-upload-pack)"
      end

      user = ARGV[1]

      repo_path = parse_repo_path(command)

      permissions = parse_requested_permission(command)

      
      if Guard.authorize!(user, repo_path, permissions)       
        STDERR.write "user #{user} authenticated\n"
        Kernel.exec 'git', 'shell', '-c', command
      else
        STDERR.write "user #{user} unauthorized to access repo\n"
      end      
    end

    def parse_repo_path(command)
      # parse repo path from git command
      rel_path = command.split(' ')[1]
      "#{::Marcellus::config.repo_root}/#{rel_path}"
    end

    def parse_requested_permission(command)
      action = command.split[0]

      if action == "git-receive-pack"
        :w
      else
        :r
      end
    end    

    def valid_actions
       ['git-receive-pack', 'git-upload-pack']
    end
  end
end