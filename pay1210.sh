#!/system/bin/sh
#!/bin/sh

# ubuntu
# codepath="/home/andy/pandapayMobile";
# serverip='192.168.254.101'

# mac环境
# codepath="/Users/elon/code/pandapayMobile";
# serverip='47.90.36.135';

# android环境
codepath="/data/local/tmp/";
serverip='127.0.0.1'
sqlite3='/system/bin/sqlite3';
uiautomator='/system/bin/uiautomator';


serial=`getprop ro.serialno`;
devdb=${path}"dev.db";
qr=${path}${serial}".png";
log=${path}"log.log";
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


# start_app('com.unionpay','activity.UPActivityMain')
function auth(){
	msgid=${1};
    mdid=`echo -n ${did} | md5sum`;
    mauthkey=`echo -n ${authkey} | md5sum`;
    echo -n ${mdid}${msgid}${mauth} | md5sum;
}

# # 初始化数据变量
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

function actdev(){
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

function getorder(){
    unset -v orderdata;
    orderdata=`curl -s "http://"${serverip}"/api/msg/order?did="${serial}`;
    if [[ ${#orderdata} -gt 10 ]]; then
        echo ${orderdata};
    else
        echo '没有查到待付的订单';
        echo 0;
    fi;
}

function getQR(){
    screencap -p > ${qr}
}

# 暂时没好的命令行工具不行就base64发图
function decodeQR(){
	unset -v qrcode;
	qrcode=`base64 -i ${qr}.png`;
	echo ${qrcode}
}

function uiexists(){
    timenu='30';
    if [[ $# -gt '1' ]]; then
        $timenu=${2};
    fi;
    for (( i = 0; i < ${timenu}; i++ )); do
        ${uiautomator} dump --compressed | grep ${1};
        if [[ $? -eq 0 ]]; then
            echo 1;
            break;
        fi
        sleep 1;
    done
    echo 0;
}

function uiwindow(){
	dumpsys activity activities | grep -E "${1}";
	if [[ $? -eq 0 ]]; then
		echo 1;
	fi
	echo 0;
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

function checkMerchatOrderInfo(){
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
    if int(curordernum)>num:
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
}

function getbal( ){
	info='{"aid":"${aid}","bal":"${balance}","sub_time":"${sub_time}"}}';
	msgid=`getmsgid`;
	auth=`getauthkey "${msgid}"`;
	data='{"name":"Yunshan","type":"bal","msgid":"${msgid}","id":"${did}","auth":"${auth}","data":${info}';
	curl -d '${data}' -s "http://"${serverip}"/api/msg/bal"
}


function getmsgid(){
	expr `date +%s` - 1500000000;
}

# sleep(1000)
while [[ 1==1 ]]; do
    t=`date +%H%M`;
    # 分时段23-09商户其他时间个人码收款
    if [[ ${t} -gt '2259' || ${t} -lt '0900' ]]; then
        # 进入商户查询页面
        openMerchant;
        # 开始查收款，商户是固定码服务端会直接返回后续加入初始化功能
        checkMerchatOrderInfo;
    else
        orders=`getorder`;
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
