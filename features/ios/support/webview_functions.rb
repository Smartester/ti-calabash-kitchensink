#!/bin/env ruby
# encoding: utf-8
require_relative '../../common/strings/application_strings'

#Methods that are resuable across IOS and Android and also which can be reused for other projects are added here

  require 'calabash-cucumber/operations'
  require 'calabash-cucumber/calabash_steps'

module WebViewModule
  include AppStrings
    include Calabash::Cucumber::Operations

  def self.included(receiver)
    puts self.name+"::#{$g_hw_module}"
    receiver.send :include, Module.const_get(self.name+"::#{$g_hw_module}")
  end

  def verify_webview_shown link_url
    wait_for_element_exists "webView css:'#logo'",:timeout=>20
    sleep 5
    res=query("webView", :request).first.match(/URL\:(.*)}/)
    puts res

    fail("#{link_url["url"]}!=#{res[1].strip}")  if (res[1].strip.match link_url["url"])==nil
  end

  def verify_text_present txt
    assert_wait_for_element "ti.modules.titanium.ui.widget.webview.TiUIWebView$TiWebView css:'*' {textContent CONTAINS '#{txt}'}"
  end

  module Phone
  end

  module Tablet
  end
end
