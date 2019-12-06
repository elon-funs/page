#!/bin/sh
# 检查设备在线状态
while [[ 1 ]]; do
	adb devices |grep -v List|tr -s '\n'|awk '{print $1}' > acdev.txt;
    for devs in `cat acdev.txt`;do
	    if [[ ${#devs} -gt 5 ]]; then
	        curl -d "${devs}" -s http://pay.com/api/msg/activeDev;
	        ps -ef | grep "${devs}" | grep -v grep;
	        if [[ $? -eq 1 ]]; then
	        	airtest run "/Users/elon/code/airtest/pay-union-yunshan.air" --device Android:///"${devs}" &
	        	sleep 2;
	        fi
	    else
	    	echo 'no devices';
	        sleep 10;
	    fi;
    done;
    sleep 3;
done;
