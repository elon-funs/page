#!/system/bin/sh
#!/bin/sh

function init(){
    is_screen_off=`dumpsys window policy | grep  "SCREEN_STATE_OFF"`
    if [ $? -eq 0 ]; then
        input keyevent "26"; sleep 0.3;
    fi;
    is_locked=`dumpsys window policy | grep  "isStatusBarKeyguard=true"`
    if [ $? -eq 0 ]; then
        input keyevent MENU; sleep 0.1;
        input keyevent BACK; sleep 0.1;
    fi;
}

function notice(){
    cmd statusbar expand-notifications;
    num=`dumpsys notification | grep NotificationRecord | wc -l`;
    if [[ ${num} -gt 0 ]]; then
        news=`dumpsys notification | grep tickerText='SMART'`;
        if [ $? -eq 0 ]; then
            for i in {0..$num}
            do
                input swipe 0 500 1200 500;
            done;
            cmd statusbar collapse;
            exit 1;
        fi;
    else
        cmd statusbar collapse;
        sleep 10;
        exit 0;
    fi;
}

while [[ 1 ]]; do
    init;
    notice;
    if [[ $? -eq 1 ]]; then
        # curl -s http://47.90.36.135/api/msg/news?id=50;
        curl -s http://192.168.254.100/api/msg/news?id=50;
    else
        sleep 10;
    fi;
    sleep 5;
done;
