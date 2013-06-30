module Marcellus
  class Authorize
    def initialize
      @user = ARGV[1]

      raise "no user provided" unless @user
    end
  end
end