require 'yaml'

module Marcellus
  class Keys
    class << self # class methods

      @@last_key_file_path = ::Marcellus::config.key_storage_location

      def add(user, key, opts={})
        opts = {flush: true}.merge(opts)

        read_keys

        @@keys[user] ||= []
        @@keys[user] << key unless @@keys[user].include?(key)
        
        save_keys

        if opts[:flush]
          flush
        end
      end

      def remove(user, key, opts={})
        opts = {flush: true}.merge(opts)

        read_keys

        if @@keys[user]
          @@keys[user].delete(key)

          if @@keys[user].empty?
            @@keys.delete(user)
          end
        end

        save_keys

        if opts[:flush]
          flush
        end      
      end

      def flush
        flush_to_authorized_keys
      end

      def key_file_path
        ::Marcellus::config.key_storage_location
      end

      def authorized_keys_path
        ::Marcellus::config.authorized_keys_path
      end

      def reload_keys
        read_keys(force: true)
      end

      private

      # save the user-key mappings to a YAML-serialized structure
      # (not the authorized_keys file)
      def save_keys
        key_file = File.open(key_file_path, 'w')

        key_file.write(YAML::dump(@@keys))

        key_file.close
      end

      # read the user-key mappings (from YAML-serialized structure)
      def read_keys(opts={})
        if !defined?(@@keys) || !@@keys || key_file_changed?

          if ! File.exists?(key_file_path)
            @@keys = {}
            return
          end

          key_file = File.new(key_file_path, 'r')
          
          @@keys = YAML::load(key_file.read)

          @@keys = {} unless @@keys

          key_file.close
        end
      end

      def flush_to_authorized_keys
        if @@keys
          shell_options = ::Marcellus::config.shell_options
          marcellus_bin = ::Marcellus::config.bin_location

          contents = ""

          @@keys.each_pair do |user, keys|
            command = "#{marcellus_bin} authenticate #{user}"

            keys.each do |ssh_key|
              contents += "command=\"#{command}\""
              contents += shell_options
              contents += ssh_key
              contents += "\n"
            end
          end

          file = File.open(authorized_keys_path, 'w')
          file.write(contents)
          file.close
        end
      end

      def key_file_changed?
        if key_file_path != @@last_key_file_path
          @@last_key_file_path = key_file_path
          true
        else
          false
        end
      end

    end
  end
end