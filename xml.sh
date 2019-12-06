#!/bin/bash
# emails=($(grep -o '(?<node*)[^/>]+' "./window_dump.xml"))
emails=`cat ./window_dump.xml`;
textstr=${emails/"<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><hierarchy rotation=\"0\">"/""};
nnode=${textstr/"</node>"/""};
# nodehi=${text/"<\/hierarchy>"/""};
# nodetext=${nodehi/"\<\/hierarchy>"/""};
# nodestr=${textstr/"*text=\"\"*bounds=\"\[*\]\"">/""};
# node=${node/"\<\/hierarchy>"/""};

# echo ${emails}
# text=`echo ${emails/hierarchy>/''}`;
# <node index="4" text="转账存款" resource-id="" class="android.widget.TextView" package="com.unionpay" content-desc="" checkable="false" checked="false" clickable="false" enabled="true" focusable="false" focused="false" scrollable="false" long-clickable="false" password="false" selected="false" bounds="[260,1630][522,1687]" />
# text=${emails//node>* text=/'aaaa'};
# list='';
# a=${emails#*text=\"}
# if [[ $? -eq 0 ]]; then
# 	list=${list}":"${a}
# 	a=${emails#*text=\"}	
# fi;

# echo here365test | sed 's/.*ere\([0-9]*\).*/\1/g'
# echo ${emails} | sed 's/.*text=\(*\).*/\1/g';
# echo  $emails | sed 's/^.*text=".*".*$/\1/g';
# text=`grep 'text="' $emails`;
# smstime=`echo ${smsbal/:639208075592*Balance:P/\",\"bal\":\"}`;
# text=`sed "s/xml*node/a/g" ./window_dump.xml`;
# echo ${text}
# echo ${nodestr}
echo ${nnode}