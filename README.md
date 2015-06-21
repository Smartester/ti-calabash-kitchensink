
Folder structure
===============
```` 
Gemfile   - gems required for running calabash test suite
README.md - Help file
run_ios.sh - Shell script required to run IOS tests
run_android.sh - Shell scripts for running android tests
calabash.exp - Expect script to compile titanium IOS build

ios-report.html - IOS test report
android-report.html - android test report
app.apk - application file for android
features - tests

features/android - android specific test code
features/common	 - common testcode for IOS and android
features/ios	 - IOS specific test code
features/tests	 - feature files
````

####Test data

````
Test data is stored in file users.rb
to use simple input data use users.rb

````

Environment variables which can be configured
===============

```` 
ENV['HW']=="tablet" or "phone"  # select tablet or phone
ENV['OS']=="ios" or "android"
```` 

Execute tests
===============


####Run tests without cleaning
	 sh run_ios.sh NA @sanity
	 sh run_android.sh NA @sanity

Getting Started
===============
#Install RUBY
* use ruby version >= 2.2.0
* Install source tree & clone source code

#To install gems needed for this project
Gems needed for this project are present in Gemfile

if bundler  is not installed install it

	gem install bundler
Run below command to install all gems needed

    bundle install

# Download and Build: Android

#Android

### Download and Install Android SDK
#####Set environment variables
	export PATH=/Users/<username>/Documents/adt-bundle-mac/sdk/tools:$PATH
	export PATH=/Users/<username>/Documents/adt-bundle-mac/sdk/platform-tools:$PATH
	export ANDROID_HOME=/Users/<username>/Documents/adt-bundle-mac/sdk
	export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

### Commands
````
Uninstall rvm - http://stackoverflow.com/questions/3558656/how-can-i-remove-rvm-ruby-version-manager-from-my-system
rvm implode

Install stable rvm (https://rvm.io/rvm/install)
\curl -sSL https://get.rvm.io | bash -s stable –ruby

cd ti-calabash-sample

Install bundler - gem install bundler

Install GEMS from Gemfile in calabash project
bundle install

Install ti calabash - https://github.com/appersonlabs/TiCalabash
npm install -g ticalabash
(Don’t use sudo instead use - sudo chown -R $USER /usr/local)

Run tests with precompiled app
sh run_ios.sh NA @san1
sh run_android.sh NA @san1
````
