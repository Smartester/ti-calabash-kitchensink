require_relative 'base_module'

module AppFeedbackModule
  include BaseModule

  def self.included(receiver)
    puts self.name+"::#{$g_hw_module}"
    receiver.send :include, Module.const_get(self.name+"::#{$g_hw_module}")
  end

  ## SAMPLE ON HOW TO INCLUDE BASE MODULES
  module Phone
    include BaseModule

  end
end
