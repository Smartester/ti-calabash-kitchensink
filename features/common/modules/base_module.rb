require_relative "../support/view_functions"
require_relative "../support/reusable_methods"
require_relative "../strings/application_strings"

module BaseModule
    include ViewModule
    include ReusableMethods
    include AppStrings
end