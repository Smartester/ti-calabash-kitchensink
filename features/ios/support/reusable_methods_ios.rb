# encoding: utf-8
#require 'rubyXL'
require_relative '../../common/strings/application_strings'
require_relative '../../common/support/reusable_methods'
require_relative '../../common/support/view_functions'


module Phone

end

module IosReusableMethods
  include AppStrings
  include ReusableMethods
  include ViewModule

  def self.included(receiver)
    receiver.send :include, Module.const_get("Phone")
  end

  #This method avoids calabash from crashing while using single quotes
  def escape_quotes_smart(str)
    return str if  !(str.include? '\'')
    #If escape quotes are used dont use again
    if str.include? '\\\''
      return str
    else
      return escape_quotes(str)
    end
  end

  # escape single quotes present within double quotes string ex: "a'b"
  def escape_quotes(str)
    return str.gsub("'", "\\\\'")
  end

  def enter_text(text, index, opt="")
    screenshot_and_raise "Index should be positive (was: #{index})" if (index<=0)
    touch("textField index:#{index-1}")
    wait_for_keyboard
    keyboard_enter_text text
    sleep(STEP_PAUSE)
    tap_keyboard_action_key if opt=="enter"
    sleep(STEP_PAUSE)
  end

  def click_on_text(text)
    sleep(STEP_PAUSE)
    puts "click_on_text (#{text})"
    touch("view text:'#{text}'")
    sleep(STEP_PAUSE)
  end

  def read_acc_label_text(label)
    query_text=$g_query_txt+"accessibilityLabel:'#{label}'"
    query(query_text, :text)[0]
  end

  def check_text_in_view(text_to_check)
    write_verified_text_to_file "check_text_in_view (#{text_to_check})"
    text_check=escape_quotes_smart(text_to_check)
    res=element_exists("view text:'#{text_check}'")
    puts "check_text_in_view #{res} (#{text_to_check})"
    if res
      flash("view text:'#{text_check}'") if $g_flash
    end
    return res
  end

  def swipe_dir(dir)
    if dir=="right"
      swipe(:right)
    elsif dir=="left"
      swipe(:left)
    end
  end

  def scroll_side_panel_and_assert(text, index=1)
    scroll_side_panel(text, index)
    assert_text_present text
  end

  #touch text and verify page title
  def touch_txt_and_verify_title(txt_touch, text=nil)
    puts "touch_txt_and_verify_title #{txt_touch}"
    click_on_text txt_touch
    sleep 2
    verify_page_title text if text!=nil
  end

  #touch text and verify text
  def touch_txt_and_verify_text(txt_touch, text)
    click_on_text txt_touch
    sleep 2
    assert_wait_for_text text
  end

  def touch_acc_label_and_verify(label_touch, label_expected)
    touch_transition_timeout=10
    touch_transition_retry=1
    touch_transition("view marked:'#{label_touch}'", "view marked:'#{label_expected}'", {:timeout => touch_transition_timeout, :retry_frequency => touch_transition_retry})
  end

  #Switch language keyboard to english. useful for localisation
  def change_keyboard_to_english
    sleep(2)
    res=query("view:'UIKBKeyplaneView'", "keyplane")[0].include? ("iPhone-Alphabetic-Keyboard_Small-Letters/Keyplane: 8 properties + 4 subtrees")
    sleep(3)
  end

  def scroll_table_to_text(text)
    puts "scroll_table_to_text #{text}"
    wait_poll({:until_exists => "view marked:'#{text}'",
               :timeout => 2}) do
      scroll("tableView", :down)
    end
  end

  def check_txt_in_webview txt
    if (query("webView", :stringByEvaluatingJavaScriptFromString => 'document.body.innerHTML')[0].match(/#{txt}/))!=nil
      return true
    end
    return false
  end

  # scroll in specified direction till partial id is found
  def scroll_assert_txt_webview(text, dir="down", count=10)
    puts "scroll_assert_txt_webview (#{text})"

    flag=0
    repeat_count=0
    while (repeat_count < count)
      repeat_count+=1
      if check_txt_in_webview text
        flag=1
        break
      end
      sleep 1
      puts "#{text} is not visible yet"
      scroll_view(dir)
    end
    sleep 2
    #puts "\nDEBUG:\n #{text}" if flag==0
    fail("Searched for the text: #{text} - but the text is not shown") if flag==0
  end

  def assert_txt_in_webview txt
    fail "text not found" if !(check_txt_in_webview txt)
  end

  def click_return_key
    tap_keyboard_action_key
  end

end
