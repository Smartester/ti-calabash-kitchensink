#!/bin/env ruby
# encoding: utf-8
require_relative '../../common/strings/application_strings'

#Methods that are resuable across Android and also which can be reused for other projects are added here
module WebViewModule
  include AppStrings

  def self.included(receiver)
    puts self.name+"::#{$g_hw_module}"
    receiver.send :include, Module.const_get(self.name+"::#{$g_hw_module}")
  end

  module Phone
  end

  module Tablet
  end
end
