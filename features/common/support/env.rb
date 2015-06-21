#!/bin/env ruby
# encoding: utf-8

STEP_PAUSE ||= (0.5).to_f

$first_run=0
$g_ios=false
$g_android=false

require_relative 'page_world'
require_relative '../strings/application_strings'
require 'xmlsimple'
require 'unicode_utils'
require_relative '../support/users'
require 'require_all'
require File.join(File.dirname(__FILE__), 'page_world')


$g_hw_module='Phone'
  if ENV['PLATFORM'] == 'ios'
  $g_ios=true
  $g_platform="Ios"
  require 'calabash-cucumber/cucumber'
elsif ENV['PLATFORM'] == 'android'
  $g_android=true
  $g_platform="Android"
  require 'calabash-android/cucumber'
end

require_relative '../../BasePages/base_page'

World(TestModule)
World(AppStrings)

