module Marcellus
  class Guard
    class << self
      def authorize!(user, repo)
        raise "no user provided" unless user      
      end
    end
  end
end