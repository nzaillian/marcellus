module Marcellus
  class Guard
    class << self
      
      def authorize(user, repo)
        
        raise "no user provided" unless user
        raise "no repo provided" unless repo

        repo_users = Repo.users(repo)

        if repo_users.include?(user)
          true
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