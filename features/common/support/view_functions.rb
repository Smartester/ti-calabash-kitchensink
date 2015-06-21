#!/bin/env ruby
# encoding: utf-8
require_relative '../strings/application_strings'

#Methods that are resuable across IOS and Android and also which can be reused for other projects are added here

if ($g_ios)
  require 'calabash-cucumber/operations'
  require 'calabash-cucumber/calabash_steps'
end

module ViewModule
  include AppStrings

  if ($g_ios)
    include Calabash::Cucumber::Operations
    ## Specify text to check and time to wait for
    def wait_for_text(text, time_out=10)
      begin
        wait_for_element_exists("#{$g_query_txt}text:'#{text}'", {:timeout => time_out.to_i})
      rescue
        return false
      end
      puts text
      flash($g_query_txt+"text:'#{text}'") if $g_flash
      return true
    end


  elsif $g_android
    def wait_for_text(text, time_out=10)
      begin
        wait_for_element_exists("#{$g_query_txt}text:'#{text}'", timeout: time_out.to_i)
      rescue
        return false
      end
      puts text
      return true
    end
  end

  def embed(a, b, c)
  end

  def check_and_click(txt, to_click="")
    str= "* text:'#{txt}'"
    wait_for_element_exists(str,{:timeout => 2})
    if to_click!=""
      str= "* text:'#{to_click}'"
    end
    touch str
  end

  def get_acc_label_text(id)
    return query($g_query_txt+"marked:'#{id}'", :text).first if $g_ios
    return query($g_query_txt+"contentDescription:'#{id}.'", :text).first if $g_android
  end

  def click_on_partial_text(text)
    touch("#{$g_query_txt}{text CONTAINS '#{text}'}")
  end

## Specify text to check and time to wait for
# This will return true even if text matches part of the sentence
  def wait_for_partial_text_shown(text, time_out=10)
    puts "wait_for_partial_text_shown (#{text})"
    query_text=($g_query_txt+"{text CONTAINS '#{text}'}")
    puts "query_text :#{query_text}:"
    begin
      wait_poll({:until_exists => query_text, :timeout => time_out.to_i}) do
        puts ":#{query_text}:"
        sleep 0.5
      end
      flash(query_text) if ($g_flash)
    rescue
      query_text=escape_quotes_smart($g_query_txt+"{text CONTAINS '#{text}'}")
      assert_element query_text
    end
    return true
  end

  #Check if part of text is shown
  def check_partial_text_shown text
    puts "check_partial_text_shown #{text}"

    if element_exists("#{$g_query_txt}{text CONTAINS '#{text}'}")
      flash("#{$g_query_txt}{text CONTAINS '#{text}'}") if ($g_flash)
      return true
    else
      return false
    end
  end

  def assert_partial_text text
    fail("text not shown #{text}") if check_partial_text_shown(text) ==false
  end

  def wait_for_label(lbl, timeout)
    timeout=timeout.to_i
    while (timeout > 0)
      timeout-=1
      break if element_exists($g_query_txt+"marked:'#{escape_quotes(lbl)}'")
      sleep 1
    end
  end

#click on accessibility labels
  def click_acc_label(id)
    query_txt = "#{$g_query_txt}marked:'#{id}'" if $g_ios
    query_txt = "#{$g_query_txt}contentDescription:'#{id}.'" if $g_android
    click_element query_txt
    puts query_txt
    sleep 1
  end

  def assert_partial_accessibility_label_text(label_text)
    array=label "view"
    array.each do |val|
      return true if val!=nil && val.match(/#{label_text}/)
    end
    fail "#{label_text} text not found"
  end

  #Check if text present or assert
  def assert_text_present(text_to_check)
    res = check_text_in_view(text_to_check)
    if not res
      val=query("visible", :text)
      puts "all show labels #{val}"
      screenshot_and_raise "assert_text_present: No element found with mark or text:#{text_to_check}:"
    else
      return res
    end
  end

  # check for elements in the array and assert if one of them is not found
  def assert_text_elements(arr)
    arr.each do |var|
      assert_text_present(var)
      puts var
    end
  end

  def assert_wait_for_element(query, time_out=10)
    begin
      wait_poll({:until_exists => query, :timeout => time_out.to_i}) do
        sleep 1
        puts "assert_wait_for_element: waiting for element"
      end
    rescue
      return false
    end
  end

  ## Assert if text to check is not shown before timeout
  def assert_wait_for_text(text, time_out=15)
    fail "Text is empty" if text==nil
    puts "assert_wait_for_text (#{text})"
    write_verified_text_to_file "assert_wait_for_text (#{text})"
    if wait_for_text(text, time_out)==false
      puts "#{query("view", :text)}" if $g_ios
      puts "#{query("*", :text)}" if $g_android
      fail("text:#{text}: not present")
    end

    return true
  end

  ## Assert if text to check is not shown before timeout
  def assert_wait_for_partial_text(text, time_out=15)
    fail "Text is empty" if text==nil
    puts "assert_wait_for_partial_text (#{text})"
    if wait_for_partial_text_shown(text, time_out)==false
      puts "#{query("view", :text)}"
      fail("text:#{text}: not present")
    end
    return true
  end

  #Wait to check if acc label appears on screen
  def assert_wait_for_acc(text, timeout=10)
    puts "assert_wait_for_acc (#{text})"
    write_verified_text_to_file "assert_wait_for_acc (#{text})"
    fail("assert_wait_for_acc text failed to find acc label:#{text}:") if (wait_for_acc_label(text, timeout)==false)
    return true
  end

  # scroll in specified direction till partial id is found
  def scroll_page_till_partial_text(text, dir="down", count=10)
    puts "scroll_page_till_partial_text (#{text})"
    write_verified_text_to_file "scroll_page_till_partial_text (#{text})"

    flag=0
    repeat_count=0
    while (repeat_count < count)
      repeat_count+=1
      if check_partial_text_shown(text)
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

  # scroll in specified direction till partial id is found
  def scroll_page_till_acc(acc, dir="down", count=10)
    write_verified_text_to_file "scroll_page_till_acc (#{acc})"
    flag=0
    repeat_count=0
    while (repeat_count < count)
      repeat_count+=1
      if check_acc_label(acc)
        flag=1
        break
      end
      sleep 1
      scroll_view(dir)
    end
    fail("acc:#{acc}: not found") if flag==0
  end

  def click_element(query)
    touch(query)
  end

  def assert_element(query)
    res = element_exists(query)
    if not res
      screenshot_and_raise "No element found for query: #{query}"
    end
    return res
  end

  def assert_element_exists(element)
    res = element_exists($g_query_txt+"text:'#{element}'")
    if not res
      screenshot_and_raise "No element found with mark or text: #{element}"
    end
    return res
  end

end
