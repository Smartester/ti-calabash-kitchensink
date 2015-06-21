# encoding: utf-8
#require 'rubyXL'
require 'date'
require_relative '../strings/application_strings'
require "unicode_utils/upcase"

#Methods that are resuable across IOS and Android and also which can be reused for other projects are added here
module ReusableMethods
  include AppStrings

  def embed(a, b, c)
  end

  def input_text(var, id=nil)
    sleep 1
    if $g_android && id!=nil
      enter_text_android(var, id)
    else
      keyboard_enter_text var
    end
    sleep 1
  end

  # escape if there are + symbols in text
  def escape_plus(str)
    if str.include? '+'
      str.gsub('+', '\\\\+')
    end
    return str
  end

  def get_localized_capitalized_string(id)
    UnicodeUtils.upcase(get_localized_string(id))
  end

  #Send resource id for string and get localized value
  def get_localized_string(id)
    $g_localized_strings||=read_xml($g_lang_strings_file)
    if $g_localized_strings[id]==nil
      puts("id #{id} string not found")
      fail("id #{id} string not found")
    end
    return $g_localized_strings[id]
  end

  def capitalize_first_letter_of_each_word txt
    txt.split.each { |i| i.capitalize! }.join(' ')
  end

  def convert_excel_date_to_str(date_int)
    d=DateTime.new(1899, 12, 30) + date_int.to_i
    return d.strftime("%d-%b-%Y")
  end

  #Create result hash for data matching criteria  @@welcome_msg_hash[criteria]
  def create_result_hash(criteria)
    @@result_hash={}
    @@welcome_msg_hash[criteria].each do |message|
      @@result_hash[message]=0
    end
    return @@result_hash
  end

#Return current date
  def get_current_time
    Time.now()
  end

  #Add days to current date
  def add_days(count)
    24*60*60*count.to_i
  end

  #Read language strings by default or else read specified file
  # $g_language_strings is set in env.rb based on command line argument TESTENV (from cucumber profile)
  def read_xml(filename=$g_language_strings)
    filename = $g_lang_strings_file
    all_strings_hash={}

    config = XmlSimple.xml_in(filename, {'KeyAttr' => 'resources/String'})
    config['string'].each do |var|
      all_strings_hash[var["name"]]=var["content"]
    end

    return all_strings_hash
  end

end



