require "active_support/core_ext/object/blank"

Dir["#{File.expand_path('..', __FILE__)}/marcellus/**/*"].each { |f| require f }

module Marcellus
end