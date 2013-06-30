require 'yaml'

module Marcellus
  class Repo
    class << self
      def add_user(repo_path, user, permissions_string=nil)

        raise "Supplied repo path seems to be invalid" unless File.exists?(repo_path)

        repo_users = users(repo_path)

        permissions = parse_permissions(permissions_string)

        repo_users[user] = permissions

        write_users(repo_path, repo_users)
      end

      def remove_user(repo_path, user)

        raise "Supplied repo path seems to be invalid" unless File.exists?(repo_path)

        repo_users = users(repo_path)

        repo_users.delete(user)

        write_users(repo_path, repo_users)
      end

      def users(repo_path)
        mc_access_path = "#{repo_path}/.mc-access"

        if ! File.exists?(mc_access_path)
          return {}
        end

        YAML::load(File.read(mc_access_path)) || {}
      end

      private

      def parse_permissions(permissions_string)
        if [nil, "", "rw"].include?(permissions_string)
          [:r, :w]
        elsif permissions_string == "r"
          [:r]
        elsif permissions_string == "w"
          [:w]
        else
          raise "invalid permissions supplied (must be 'r', 'w' or 'rw')"
        end
      end

      def write_users(repo_path, users)
        mc_access_path = "#{repo_path}/.mc-access"
        file = File.new(mc_access_path, 'w')
        file.write(YAML::dump(users))
        file.close        
      end
    end
  end
end