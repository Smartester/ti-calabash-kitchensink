# encoding: utf-8
#require 'rubyXL'
require_relative '../../common/strings/application_strings'
require_relative '../../common/support/reusable_methods'

module Phone
  #Scroll to text in side panel
  def scroll_side_panel(text, index=1)
    scroll_page_and_assert_text(text)
  end
end

module Tablet
  def scroll_home_biscuits(txt)
    scroll_page_and_assert_text txt
  end
end

#Methods that are resuable across IOS and Android and also which can be reused for other projects are added here
module AndroidReusableMethods
  include AppStrings
  include ReusableMethods

  def self.included(receiver)
    receiver.send :include, Module.const_get("#{$g_hw_module}")
  end

  def ti_enter_details(text, index)
    sleep 1
    query("all TiEditText index:#{index}", setText: "#{text}")
    sleep(1)
  end

  def scroll_side_panel_and_assert(text, index=1)
    scroll_side_panel(text, index)
    assert_text_present text
  end

  def enter_text_android(text, id=nil)
    sleep 2
    if id!=nil
      enter_text("android.widget.EditText contentDescription:'#{id}.'", text)
    else
      text=text.gsub(' ', '%s')
      command = "#{default_device.adb_command} shell input text '#{text.to_s}'"
      raise "Could not send text" unless system(command)
    end

  end

  #This method avoids calabash from crashing while using single quotes
  def escape_quotes_smart(str)
    return str if !(str.include? '\'')
    #If escape quotes are used dont use again
    if str.include? '\\\''
      return str
    else
      return escape_quotes(str)
    end
  end


  # escape single quotes present within double quotes string ex: "a'b"
  def escape_quotes(str)
    return str.gsub("'", "\\\\\'")
  end

  def click_on_text(text)
    puts "click_on_text(#{text})"
    touch "* text:'#{text}'"
    sleep 1
  end

  def click_back_button
    performAction('go_back')
    sleep 2
  end

  def read_acc_label_text(label)
    query_text=$g_query_txt+"contentDescription:'#{text}.'"
    query(query_text, :text)[0]
  end

  def wait_for_acc_label(text, timeout=10)
    query_txt=$g_query_txt+"contentDescription:'#{escape_quotes_smart(text)}.'"
    begin
      wait_poll({:until_exists => query_txt, :timeout => timeout.to_i}) do
        puts text
        sleep(0.5)
      end
    rescue
      return false
    end
    return true
  end

  def check_text_in_view(txt)
    write_verified_text_to_file "check_text_in_view (#{txt})"

    begin
      res=query "* text:'#{txt}'"

      if res.count==0
        puts "check_text_in_view(#{txt}) res=false"
        return false
      else
        puts "check_text_in_view(#{txt}) res=true"
        return true
      end
    rescue
      return false
    end
  end

  #Using this for acc label
  def wait_for_page_to_load(text, time_out)
    begin
      wait_poll({:until_exists => $g_query_txt+"contentDescription:'#{text}.'", :timeout => time_out}) do
        puts "wait_for_page_to_load: checking text #{text}"
      end
    rescue
      return false
    end
    return true
  end



  def scroll_view(dir, index=0)
    if (dir=="up")
      perform_action('drag', 50, 50, 70, 90, 10)
    elsif (dir=="down")
      perform_action('drag', 50, 50, 90, 70, 10)
    elsif (dir=="right")
      perform_action('drag', 90, 50, 80, 50, 10)
    end
  end

  # scroll in specified direction till id is found
  def scroll_page_and_assert_text(id, dir="down", till_id=nil, count=10, index=0)
    repeat_count=0
    sleep 1
    write_verified_text_to_file "scroll_page_and_assert_text (#{id})"
    puts element_exists("* contentDescription:'#{id}.'") || element_exists("* text:'#{id}'")
    return if (element_exists("* contentDescription:'#{id}.'") || element_exists("* text:'#{id}'"))

    puts "scroll_page_and_assert_text (#{id})"

    while (repeat_count < count)
      repeat_count+=1
      scroll_view(dir)
      #if text we are searching is found break on success
      break if (element_exists("* contentDescription:'#{id}.'") || element_exists("* text:'#{id}'"))

      #If text is not found even after scrolling till end of page then fail
      if till_id!=nil && (element_exists("* contentDescription:'#{till_id}.'") || element_exists("* text:'#{till_id}'"))
        fail "id/text #{id} not present on screen"
      end

      sleep 0.5
    end
    fail "id/text #{id} not present on screen" if repeat_count==10
    sleep 2
  end

  def get_nav_bar_title
    query("* marked:'navbarTitle.'", :text).first
  end


  def scroll_table_to_row row_num
    scroll_to_row("ListView", row_num.to_i-1)
    sleep 2
  end

  def enter_date_android(date_int)
    day, month, year= (date_int).split(/-/)
    puts "day#{day}, month#{month}, year#{year}"
    sleep(1)

    touch("all TiEditText index:2")
    sleep 3
    query("datePicker", {:method_name => :updateDate, :arguments => [year.to_i, month.to_i-1, day.to_i]})
    sleep 1
    performAction('go_back')
    sleep 2
    return

    #Commented code is useful to set date in nexus4 (OS 4.3)
    puts "DATE: #{day}#{get_day_number_suffix(day)} #{month} #{year}"
    #TODO remove if not needed

    touch("all TiEditText index:3")
  end

  def click_return_key
    press_enter_button
  end
end
