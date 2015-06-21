#!/bin/sh
clear
DATE=`date +%d-%m-%Y-%H-%M`

export LC_CTYPE=en_US.UTF-8

if [ "$#" -le "1" ]; then
	echo "\n4 ARGUMENTS NEEDED"
	echo "1) clean(clean project) or NA (for running project without cleaning"
	echo "2) Tags selected for test run ex: @sanity or @reg"
	exit 1
fi

PROJ_FOLDER=../KitchenSink
tagged_test=$2
APP_BUNDLE_PATH_VAR="../apps/KitchenSink.app"

CUCUMBER_PROFILE=ios
SIMULATOR_DEVICE="iPhone 6 (8.2 Simulator)"

calabash-ios sim locale en

if [ "$1" == "clean" ] ; then
	echo "Cleaning and rebuilding project folder:${PROJ_FOLDER}"
	echo "******** ####  Updating All Projects"
	cp build/calabash.exp ${PROJ_FOLDER}
	cp Gemfile ${PROJ_FOLDER}
	cd ${PROJ_FOLDER}/
	echo expect ../titanium-calabash/build/calabash.exp
	expect ../titanium-calabash/build/calabash.exp
	cd -

  echo "******** ####  Deleting old App file "$APP_BUNDLE_PATH_VAR
  if [ ! -d $APP_BUNDLE_PATH_VAR ]; then
 	 echo -e "\n\n\n*** ERROR: APP NOT COMPILED *** \n\n\n\n\n"
 	 exit 1
  fi

	killall "iPhone Simulator"
	killall Xcode                                                                 ]
	sleep 1
fi

SIM_NAME='iPhone 6' SIM_OS='8-2' DEVICE_TARGET=${SIMULATOR_DEVICE} PLATFORM=ios APP_BUNDLE_PATH=$APP_BUNDLE_PATH_VAR bundle exec cucumber -p ios --tags $2 -f html -o ios_report.html
echo SIM_NAME='iPhone 6' SIM_OS='8-2' DEVICE_TARGET=${SIMULATOR_DEVICE} PLATFORM=ios APP_BUNDLE_PATH=$APP_BUNDLE_PATH_VAR bundle exec cucumber -p ios --tags $2 -f html -o ios_report.html

open ios_report.html
