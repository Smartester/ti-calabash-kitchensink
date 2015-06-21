#!/bin/sh
clear
DATE=`date +%d-%m-%Y-%H-%M`

export LC_CTYPE=en_US.UTF-8

if [ "$#" -le "1" ]; then
	echo "\n2 ARGUMENTS NEEDED"
	echo "1) clean(clean project) or NA (for running project without cleaning"
	echo "2) Tags selected for test run ex: @sanity or @reg"

	exit 1
fi

if [ -z "$2" ] ; then
	echo "Tags not specified using @failed"
	exit 1
else
	tagged_test=$2
fi

sh start_device.sh S4_4.3

tagged_test=$2
APK_FILE="../apps/KitchenSink.apk"

#Temp fix until android tablet is run on different machine
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
STRINGS_FOLDER=features/test_data/$LANG_STR/

ADB=adb
#ADB=$ANDROID_HOME/platform-tools/adb
which $ADB
CUCUMBER_PROFILE=android

$ADB devices


rm -rf test_servers/
echo "Resigning APP"
calabash-android resign $APK_FILE
calabash-android build $APK_FILE

echo adb install -r $APK_FILE
adb install -r $APK_FILE

echo adb install -r test_servers/*.apk
adb install -r test_servers/*.apk

echo "********* BEGINNING OF TESTS *********"

echo DEBUG=1 OS=android bundle exec calabash-android run $APK_FILE -p $CUCUMBER_PROFILE --tag $tagged_test   -f html -o android_report.html  -f junit -o features/report/junit/$3
OS=android bundle exec calabash-android run $APK_FILE -p $CUCUMBER_PROFILE --tag $tagged_test  -f html -o android_report.html  -f junit -o features/report/junit/$3

open android_report.html