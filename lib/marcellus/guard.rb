module Marcellus
  class Guard
    class << self
      
      def authorize(user, repo, requested_permission)
        
        raise "no user provided" unless user
        raise "no repo provided" unless repo

        repo_users = Repo.users(repo)

        if repo_users.include?(user)
          user_permissions = repo_users[user]

          if user_permissions && user_permissions.include?(requested_permission)
            true
          else
            false
          end
        else
          false
        end
      end

      private

      def valid_actions
        ['git-receive-pack', 'git-upload-pack']
      end
    end
  end
end