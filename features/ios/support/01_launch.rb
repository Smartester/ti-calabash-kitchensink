require 'calabash-cucumber/launcher'

Before do |scenario|
  sleep 5

  @calabash_launcher = Calabash::Cucumber::Launcher.new
  initialize_all
  scenario_tags = scenario.source_tag_names
  if scenario_tags.include?('@reset')
    @calabash_launcher.reset_app_sandbox(:reset => 1)
    @calabash_launcher.reset_app_jail
    sleep 5
  end

  if scenario_tags.include?('@reinstall')
    @calabash_launcher.reset_app_jail
  end

  unless @calabash_launcher.calabash_no_launch?
    @calabash_launcher.relaunch(:timeout => 60) if !scenario_tags.include?('@reset')
    @calabash_launcher.relaunch(:timeout => 60, :reset => true) if scenario_tags.include?('@reset')
    @calabash_launcher.calabash_notify(self)
  end
end

AfterStep do |scenario|
  sleep 0.5 # Do something after each step.
end

After do |scenario|
  screenshot_embed
  #
  #if scenario.failed?
  #  screenshot_embed
  #end

  scenario_tags = scenario.source_tag_names
  if scenario_tags.include?('@reset-after')
    reset_app_sandbox
  end

  unless @calabash_launcher.calabash_no_stop?
    calabash_exit
    if @calabash_launcher.active?
      @calabash_launcher.stop
    end
  end
end
