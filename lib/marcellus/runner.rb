module Marcellus
  class Runner
    def initialize
      
      if ARGV[0] == "authorize"
        Authorize.new
      
      elsif ARGV[0] == "addkey"
        Keys.add(ARGV[1], ARGV[2])
      
      elsif ARGV[0] == "removekey"
        Keys.remove(ARGV[1], ARGV[2])
      end
    
    end
  end
end