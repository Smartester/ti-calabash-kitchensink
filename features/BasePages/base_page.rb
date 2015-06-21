# encoding: utf-8

require 'calabash-cucumber/ibase' if $g_ios
require_relative '../ios/support/reusable_methods_ios' if $g_ios
require_relative '../ios/support/webview_functions' if $g_ios

require 'calabash-android/abase' if $g_android
require_relative '../android/support/reusable_methods_android' if $g_android
require_relative '../android/support/webview_functions' if $g_android

require_all "features/common/modules/*.rb"

require_relative '../common/support/reusable_methods'
require_relative '../../features/common/strings/application_strings'
require_relative '../common/support/view_functions'
require 'differ'

$g_strings_set=false

puts $g_ios
puts $g_android

if $g_ios
  class BaseClass < Calabash::IBase
    include IosReusableMethods

  end
elsif $g_android
  class BaseClass < Calabash::ABase
    include AndroidReusableMethods

  end
end

class BasePage < BaseClass
  include ViewModule
  include ReusableMethods
  include AppStrings
  include WebViewModule

  def initialize
  end

end