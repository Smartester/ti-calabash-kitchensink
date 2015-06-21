#!/bin/bash

export PATH=/Applications/Genymotion\ Shell.app/Contents/MacOS/:$PATH
export PATH=/Applications/Genymotion.app/Contents/MacOS/:$PATH

#First argument is genymotion device name
killall -9 genymotion
killall -9 adb
killall -9 player

adb kill-server
sleep 2

c=1
while [ $c -le 5 ]
do
    adb kill-server
    player --vm-name $1 &
    adb wait-for-device
		sleep 2
    adb start-server
    sleep 15
    res=`adb get-state`;echo $res

    if [ $res = "device" ]
    then
        break
    else
        echo "repeat simulator launch"
    fi
done

adb wait-for-device;echo "device ready now";sleep 10
adb shell input keyevent 82


