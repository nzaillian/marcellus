require 'yaml'

module Marcellus
  class Repo
    class << self
      def add_user(repo_path, user)
        mc_access_path = "#{repo_path}/.mc-access"

        raise "Supplied repo path seems to be invalid" unless File.exists?(repo_path)

        repo_users = users(repo_path)

        repo_users << user unless repo_users.include?(user)

        write_users(repo_path, users)
      end

      def remove_user(repo_path, user)

        raise "Supplied repo path seems to be invalid" unless File.exists?(repo_path)

        repo_users = users(repo_path)

        repo_users.delete(user)

        write_users(repo_path, users)
      end

      def users(repo_path)
        mc_access_path = "#{repo_path}/.mc-access"
        file = File.new(mc_access_path, 'r')
        users = YAML::load(file.read) || []
        file.close        
        users
      end

      private

      def write_users(repo_path, users)
        mc_access_path = "#{repo_path}/.mc-access"
        file = File.new(mc_access_path, 'w')
        file.write(YAML::dump(users))
        file.close        
      end
    end
  end
end