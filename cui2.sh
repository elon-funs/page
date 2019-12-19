#!/system/bin/sh
#!/bin/sh


# 环境-ubuntu
# codepath="/home/andy/pandapayMobile/";
# serverip='192.168.254.101'

# 环境-mac
codepath="/Users/elon/code/pandapayMobile/";
# serverip='47.90.36.135';
# qr='/Users/elon/code/pandapayMobile/qr.png';

# 环境-android
# codepath="/data/local/tmp/";
serverip='127.0.0.1';
sqlite3='/system/bin/sqlite3';
uiautomator='/system/bin/uiautomator';


# 预配置文件
serial=`getprop ro.serialno`;
devdb=${codepath}"dev.db";
qr=${codepath}${serial}".png";
xml=${codepath}"window_dump.xml";
log=${codepath}"log.log";
did='1';
aid='1';
authkey="d7ad4ab5f10cf14cc4f634f18e968c19"


# activities 
# 收款码=UPActivityPaymentQrCodeIn
# 收款码收款记录=UPActivityP2PTransferRecord
# 商户服务=UPActivityWeb
# 会员中心收款记录=UPReactNativeActivity
# 设置收款金额附言=UPActivityP2PTransferSetAmount
# 待付款二维码码=UserDictionaryProvider
# 首页=UPActivityWelcome
# 主页=UPActivityMain

# 1.工具函数 ######################################################
# 下载页面
am force-stop com.android.stk;
monkey -p com.android.stk -c android.intent.category.LAUNCHER 1;

function check(){
    phnu="${1}";
    senttime=`date +%s`;
    senttime=`expr $senttime \* 1000 - 172800000`;
    loaded=`${sqlite3} ${sms} "SELECT _id FROM sms WHERE date > '${senttime}' and address='SMARTLoad' AND body like '%${phnu}%' LIMIT 1"`;
    is_load=`expr 1 + $loaded`;
    if [ ${is_load} > 1 ]; then
        lsms=`${sqlite3} ${sms} "SELECT body FROM sms WHERE _id='${loaded}'"`;
        t99=`echo ${lsms/:639208075592 has loaded Sakto Surf 99 (P94.60) to 63/\",\"amt\":\"99\",\"phone\":\"0}`;
        t299=`echo ${t99/:639208075592 has loaded GIGA VIDEO 299 (P285.72) to 63/\",\"amt\":\"299\",\"phone\":\"0}`;
        bal=${t299/\. New Load Wallet Balance:P/\",\"bal\":\"};
        ref=${bal/\. Ref:/\",\"ref\":\"};
        r='{"name":"SR","type":"check","did":"1","mid":"'${loaded}'","time":"'${ref}'"}';
        a=`curl -d "${r}" -s "${url}"index`; wait;
    echo $a >> ${log};
        unset -v r;
        echo 0;
    else
        echo ${1};
    fi;
}

function get_xml(){
    {
        rm -f ${xml};
        for (( i = 0; i < 110; i++ )); do
            uiautomator dump --compress ${xml};
            if [[ -f ${xml} ]]; then
                break;
            fi
            sleep 1;
        done;
        screencap -p > ${qr};
    } || {
        screencap -p > ${qr};
    }
}

# 清除无用xml
function xml_format(){
    unset -v fromatxml;
    fromatxml=${1};
    echo {$fromatxml} |sed 's/>/\n/g'|sed '/^<node/!d'|sed '/text=""/d' |sed '/text="  "/d';
}

# sqlite中读取和存储当日订单数量
function opsql{
    # select count(*) t_order from `order` where oid like '20191212%'
    unset -v cur_sql;
    cur_sql=${1};
    sqlite3 ${devdb} "${cur_sql}";
}

# "key":"value"字符串中,根据K取出v
function get_text(){
    unset -v textkv;
    textkv=${1};
    echo ${textkv} |sed 's/.*${textkv}":"//' |sed '/".*//';
}

function get_xy(){
    unset -v centerX;
    unset -v centerY;

    instance="";
    instance=${instance:=$2};
    instance=${instance:=1};
    xyxml=${3};
    temp=`cat "${xyxml}" |sed 's/>/\n/g' |grep "$1" |sed -n {$2}p`;
    temp=`echo ${temp%]\"*}`;
    temp=`echo $temp| awk '{print $NF}'`;

    if [[ ! "$temp" == "" ]]; then
        temp=`echo ${temp/bounds=/}`
        temp=`echo $temp|  sed 's/"//g'|  sed 's/\[//g'|  sed 's/\]/\n/g'`
        p1=`echo $temp| awk '{print $1}'`
        p2=`echo $temp| awk '{print $2}'`
        #定义四个变量，用例存储找到的属性的四个坐标值
        p1x=`echo ${p1%,*}`
        p1y=`echo ${p1#*,}`
        p2x=`echo ${p2%,*}`
        p2y=`echo ${p2#*,}`

        let centerX=$p1x/2+$p2x/2;
        let centerY=$p1y/2+$p2y/2;
    else
        echo `date +%m%d%H%M%S` get_xy $1 failed >> ${codepath}"error.log";
        screencap -p ${codepath}"`date +%m%d%H%M%S`".png;
    fi;
}

function uiwindow(){
    dumpsys activity activities | grep -E "${1}";
    if [[ $? -eq 0 ]]; then
        echo 1;
    fi
    echo 0;
}

# 2.辅助函数 ######################################################
function auth(){
    msgid=${1};
    mdid=`echo -n ${did} | md5sum`;
    mauthkey=`echo -n ${authkey} | md5sum`;
    echo -n ${mdid}${msgid}${mauth} | md5sum;
}

function getQR(){
    screencap -p > ${qr};
}

# 初始化数据变量
function getdevinfo(){
    unset -v devinfo;
    devinfo=`curl -s "http://"${serverip}"/api/msg/dev?did="${serial}`;
    if [[ ${#devinfo} -gt 5 && ${#devinfo} -gt 30 ]]; then
        devinfos=`echo ${devinfo} | awk '{split($0,arr,",");for(i in arr) print arr[i]}'`;
        ${did}=${devinfos[0]};
        ${aid}=${devinfos[1]};
        ${authkey}=${devinfos[2]};
        echo 1;
    else
        echo '请检查设备接口';
        echo 0;
    fi;
}

# 暂时没好的命令行工具不行就base64发图
# function decodeQR(){
function encodeQR(){
    unset -v qrcode;
    qrcode=`base64 -i ${qr}.png`;
    echo ${qrcode};
}

function getmsgid(){
    expr `date +%s` - 1500000000;
}

function opendev(){
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

function getnotification(){
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

# 3.业务函数 ######################################################
    # 个人版[动态码]：取待付订单，进入并生成二维码，3分钟内每2钞检测当前二维码页面的付款信息，然后上报订单详情，
    
    # 商户版[固定码]：进入商户收款明细页，并检测当前页面订单信息，在本地sqlite检查并上报每条订单订单，注意9-23点的工作时间以及0点的页面切换
function getopendingorder(){
    unset -v orderdata;
    orderdata=`curl -s "http://"${serverip}"/api/msg/order?did="${serial}`;
    if [[ ${#orderdata} -gt 10 ]]; then
        echo ${orderdata};
    else
        echo '没有查到待付的订单';
        echo 0;
    fi;
}

function openOrder(){
    loadnum=${1};
    loadphone=`check "${loadnum}"`; wait;
    if [[ "${loadphone}" == "${loadnum}" ]]; then
        input tap 618 485; sleep 0.2;
        input tap 620 310; sleep 0.3;
        input tap 550 500; sleep 0.2;
        input text "${loadnum}"; sleep 0.2;
        input tap 880 680; sleep 0.2;
        input tap 680 1510; sleep 0.2;
        input tap 780 460; sleep 0.3;
        input tap 905 1082; sleep 0.3;
    fi;
}

function createOrder(){
    step=0;
    if [[ uiexists "收款码"` -eq 1 ]];then
        step=1;
        input tap 880 680; sleep 0.2;
    fi;
    if [[ uiexists "清除金额"` -eq 1 ]];then
        step=2;
        input tap 880 680; sleep 0.2;
    fi;
    if [[ uiexists "设置金额"` -eq 1 ]];then
        step=3;
        input tap 880 680; sleep 0.2;
    fi;
    if [[ step -eq 0 ]];then
        openOrder;
        sleep 1;
        uiexists "收款码";
        uiexists "设置金额";
    fi;
    uiexists "请输入收款金额" .set_text(order['amount'])
    uiexists "20字以内（可不填）" .set_text(order['m_trade_no'])
    input tap 880 680; sleep 0.2;
}

function getpaystate(){
    paid=0;
    amount='0';
    for (( i = 0; i < 180; i++ )); do
        if [[ ${paid} -eq 0 ]]; then
            paid=`uiexists '总计'`;
            if [[ paid==1 ]]; then
                amount=`uiexists order['amount']`;
                # upsql="UPDATE `order` SET `pay_state`=%d, `step`= %d WHERE `id`= %s;" % (1,3,order['id'])
                # opsql(upsql,1,up=True)
                clearamt=`uiexists "清除金额"`;
                if[[ ${clearamt} -eq 1 ]]; then
                    # poco(text="清除金额").click()
                    tap;
                fi;
            fi;
        fi;
        sleep(1)
    done
    return 0;
}

function openMerchant(){
	if [[ uiexists "收款明细" == 1 ]]; then
        init()
        uiexists "收款码" .click()
        uiexists "商户收款" .click()
        for i in range(1,60 ]]; then
            if uiexists "收款记录"` == 1 :
                break
            sleep(1)
        uiexists "收款记录" .click()
    # 为刷新页面
    # uiexists "最近3天" .click()
    sleep(1)
    # 防止00点分页的特殊处理。服务端同步处理
    time_int=int(time.time())
    t=time.strftime('%H%M%S', time.localtime(time_int))
    if [[ t>'000130' ]]; then
        uiexists "今天" .click()
}    

# 付款凭证号：31191125862881008231 账户卡号：6217****6674 金额：2.00元 2019/11/26 00:00:47 }
function getMerchantPayState(){
    time_int=int(time.time())
    t=time.strftime('%H%M%S', time.localtime(time_int))
    if [[ t>'000130' ]]; then
        field='order1'
    else:
        field='order3'
    
    sql=("SELECT `"+ field +"` FROM `dev` WHERE `serial`="+serial)
    ordernum=opsql(sql,2)
    if [[ len(list(loadsms))>0 ]];then
        for row in ordernum:
            num=row[0]
    else;
        num=0;
    fi;
    curordernum=poco("com.unionpay:id/view_content_container").child("android.webkit.WebView").offspring("app").child("android.view.View")[1].child("android.view.View")[4].get_text()
    if [[ int(curordernum) -gt num  ]]; then
        info=''
        orderinfo=poco("com.unionpay:id/view_content_container").child("android.webkit.WebView").offspring("app").child("android.view.View")[1].child("android.view.View")[5].get_text()
        info=orderinfo.replace(' ','').replace('付款凭证号：','{"payid":"').replace('账户卡号：','","payorAccount":"').replace('金额：','","amount":"').replace('元','","paytime":"')
        info+='"}}'
        # echo ${info}

        # orderdata=eval(info)
        # echo ${orderdata['payi}'])
        msgid=time_int-1500000000
        auth=authkey(serial,msgid)
        data=str('{"id": 50, "auth": "'+auth+'", "name": "Yunshan", "type": "notice", "msgid": "401841707", "sub_time": "'+str(time_int)+'","data":'+info)
        cmd='curl -d '+ data +' -s http://pay.com/api/msg/index';
        (cmd)
        upsql="UPDATE `dev` SET `%s`='%s' WHERE `serial`= '%s';" % (field,curordernum,serial)
        opsql(upsql,2,True)
    fi;
}

function getbal( ){
	info='{"aid":"${aid}","bal":"${balance}","sub_time":"${sub_time}"}}';
	msgid=`getmsgid`;
	auth=`getauthkey "${msgid}"`;
	data='{"name":"Yunshan","type":"bal","msgid":"${msgid}","id":"${did}","auth":"${auth}","data":${info}';
	curl -d '${data}' -s "http://"${serverip}"/api/msg/bal"
}


# 订单列表页面分析,输入"key":"value"
function get_orderlist(){
    unset -v orderlistxml;
    orderlistxml=${1};
    echo {$orderlistxml} |sed '/订单详情/d' |sed '/实付金额/c "amt":' |sed '/交易类型/c "paytype":' |sed '/付款卡/c "pact":' |sed '/付款/c 2' |sed '/收款人/c "payor":' |sed '/收款卡/c "ract":' |sed '/订单时间/c "paytime":' |sed '/订单状态/c "paystate":' |sed '/交易关闭/c 0' |sed '/交易成功/c 1' |sed '/交易流水号/c "payid":' |sed '/附言/c "keyword":' |sed 's/ resource.*//g' |sed 's/\<node.*text=//g' |sed 'N;s/\n/''/g' |tr '\n' ',' |sed '/,$//'`;
}

# 单个订单详情页面分析,输入"key":"value"
function get_orderdetail(){
    unset -v orderdetailxml;
    orderdetailxml=${1};
    echo {$orderdetailxml} |sed '/订单详情/d' |sed '/实付金额/c "amt":' |sed '/交易类型/c "paytype":' |sed '/付款卡/c "pact":' |sed '/付款/c 2' |sed '/收款人/c "payor":' |sed '/收款卡/c "ract":' |sed '/订单时间/c "paytime":' |sed '/订单状态/c "paystate":' |sed '/交易关闭/c 0' |sed '/交易成功/c 1' |sed '/交易流水号/c "payid":' |sed '/附言/c "keyword":' |sed 's/ resource.*//g' |sed 's/\<node.*text=//g' |sed 'N;s/\n/''/g' |tr '\n' ',' |sed '/,$//'`;
}


# sleep(1000)

# 4.主进程 ######################################################
# monkey -p com.unionpay -c android.intent.category.LAUNCHER 1;
# start_app('com.unionpay','activity.UPActivityMain')
monkey -p com.unionpay -c activity.UPActivityMain 1;
while [[ 1==1 ]]; do
    t=`date +%H%M`;
    # 分时段23-09商户其他时间个人码收款
    if [[ ${t} -gt '2259' || ${t} -lt '0900' ]]; then
        # 进入商户查询页面
        openMerchant;
        # 开始查收款，商户是固定码服务端会直接返回后续加入初始化功能
        checkMerchatOrderInfo;
    else
        orders=`getpendingorder`;
        if [[ ${orders} != '0' ]]; then
            # date >> ${log}
            orderlist=`echo $orders | awk '{split($0,arr,",");for(i in arr) print arr[i]}'`;
            actdev;
            wait;
            openOrder;
            wait;
            createOrder "${orderlist[*]}";
            wait;
            sleep 2;
            # 销毁本次变量防止幻读
            unset -v orderlist;
            unset -v orders;
            input keyevent HOME;
            input keyevent "223";
            sleep 15;
        fi;
    fi;
    sleep 5;
done;
