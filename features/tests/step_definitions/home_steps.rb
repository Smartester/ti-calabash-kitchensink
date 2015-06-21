Given(/^I am Home screen$/) do
  txt="Controls"
  wait_for_element_exists "* text:'#{txt}'"
end

Then(/^I wait to see text "(.*?)"$/) do |var|
  wait_for_element_exists "* text:'#{var}'"
end

Then(/^I enter text "(.*?)"$/) do |var|
  touch "TiUISearchBar" if $g_ios
  sleep 2
  keyboard_enter_text var

end

Then(/^I clear text from search bar$/) do
  clear_text "UISearchBar" if $g_ios
  clear_text if $g_android
end

When(/^I wait to see label heading$/) do
  query_txt="* text:'I am a textarea'"
  wait_for_element_exists query_txt
end

When(/^I choose "(.*?)" on home screen$/) do |var|
   txt= "* text:'#{var}'"
   wait_for_element_exists txt
  touch txt
end

Then(/^I must not see "(.*?)"$/) do |arg1|
  wait_for_elements_do_not_exist "* text:'#{arg1}'"
end
