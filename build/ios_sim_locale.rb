require 'plist'
require 'colorize'


class SimLocale
  LANG_HASH||={
      "en_US" => {"AppleLanguages" => "en", "AppleLocale" => "en_US"},
      "en_GB" => {"AppleLanguages" => "en", "AppleLocale" => "en_GB"},
      "fr_FR" => {"AppleLanguages" => "fr", "AppleLocale" => "fr_FR"},
      "th_TH" => {"AppleLanguages" => "th", "AppleLocale" => "th_TH"},
      "es_ES" => {"AppleLanguages" => "es", "AppleLocale" => "es_ES"},
      "tr_TR" => {"AppleLanguages" => "tr", "AppleLocale" => "tr_TR"},
      "ar_QA" => {"AppleLanguages" => "ar", "AppleLocale" => "ar_QA"},
      "de_DE" => {"AppleLanguages" => "de", "AppleLocale" => "de_DE"},
      "id_ID" => {"AppleLanguages" => "id", "AppleLocale" => "id_ID"},
      "it_IT" => {"AppleLanguages" => "it", "AppleLocale" => "it_IT"},
      "es_AR" => {"AppleLanguages" => "es", "AppleLocale" => "es_AR"},
      "es_MX" => {"AppleLanguages" => "es", "AppleLocale" => "es_MX"},
      "ko_KR" => {"AppleLanguages" => "ko", "AppleLocale" => "ko_KR"},
      "ja_JP" => {"AppleLanguages" => "ja", "AppleLocale" => "ja_JP"}
  }

  def change_sim_locale(sim_os, sim_name, sim_locale)
    puts "change_sim_locale"
    puts  "#{sim_os}, #{sim_name}, #{sim_locale}"
    sim_path=""
    found=false

    #get home folder
    home_folder=`echo ~`.strip

    #navigate to core devices folder
    core_devices="#{home_folder}/Library/Developer/CoreSimulator/Devices"
    `cd #{core_devices}`
    #list all dirs
    all_sims=Dir["#{core_devices}/*"]

    #puts all_sims
    all_sims.each do |each_sim|
      sim_info = Plist::parse_xml("#{each_sim}/device.plist")
      if sim_info["name"] == sim_name && sim_info["runtime"].match(sim_os)
        sim_path= core_devices+"/"+sim_info["UDID"]
        found=true
        break
      end
    end

    if !found
      puts "ERROR: No compatible simulator found".red
      fail "" 
    end

    #execute plist buddy command
    global_pref_path=sim_path+"/data/Library/Preferences/.GlobalPreferences.plist"
    #puts global_pref_path
    `echo #{global_pref_path}`

    locale= sim_locale

    #puts LANG_HASH["#{sim_locale}"]
    abort if LANG_HASH["#{sim_locale}"]==nil # if locale is not specifed stop tests

    puts "#{LANG_HASH["#{locale}"]["AppleLanguages"]}"
    puts "#{LANG_HASH["#{locale}"]["AppleLocale"]}"

    `/usr/libexec/PlistBuddy #{global_pref_path} -c "Add :AppleLanguages:0 string '#{LANG_HASH["#{locale}"]["AppleLanguages"]}'"`
    `/usr/libexec/PlistBuddy #{global_pref_path} -c "Set :AppleLocale '#{LANG_HASH["#{locale}"]["AppleLocale"]}'"`

  end
#change_sim_locale(ENV['SIM_OS'],ENV['SIM_NAME'],ENV['LOCALE'])

end
