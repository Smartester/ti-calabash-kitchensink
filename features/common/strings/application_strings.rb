# encoding: UTF-8
#based on App, Application strings are loaded from
module AppStrings

  def get_val(txt)
    eval("@@#{txt}")
  end

  # setting global vars to make queries reusable
  def set_query_text
    $g_flash = false # variable use to check flash feature on IOS (for highlighting)  / This is always false for android

    if ENV['PLATFORM'] == 'ios'
      $g_query_txt = "view "
      if ENV['FLASH'] == "1"
        $g_flash = true
      end

    elsif ENV['PLATFORM'] == 'android'
      $g_query_txt= "* "
    end
  end


end
