# -*- encoding=utf8 -*-
__author__ = "elon"

import time
import pymysql
import sqlite3
import requests
import sys
import hashlib
import zxing

from airtest.core.api import *
from airtest.core.android.adb import *
from poco.drivers.android.uiautomation import AndroidUiautomationPoco

args=sys.argv[4]
connect_device(args)
serial=args.replace('Android:///','')

# 线上环境
# devdb="/Users/elon/code/pandapayMobile/dev.db"
# qr="/Users/elon/code/pandapayMobile/"+serial+".png"
# log="/Users/elon/code/pandapayMobile/log.log"
# serverip='47.90.36.135'

# ubuntu
# devdb="/home/andy/pandapayMobile/dev.db"
# qr="/home/andy/pandapayMobile/"+serial+".png"
# log="/home/andy/pandapayMobile/log.log"
# serverip='192.168.254.101'

# mac环境
devdb="/Users/elon/code/pandapayMobile/dev.db"
qr="/Users/elon/code/pandapayMobile/"+serial+".png"
log="/Users/elon/code/pandapayMobile/log.log"
serverip='127.0.0.1'

newadb=ADB(serialno=serial)
poco = AndroidUiautomationPoco(use_airtest_input=True,screenshot_each_action=False)

auto_setup(__file__)

def opsql(sql,db=1,up=False):
	if db==1:
		db = pymysql.connect(serverip,"root","pwd123!@#","pandapay")
	else:
		db=sqlite3.connect(devdb)
	cursor = db.cursor()	 
	cursor.execute(sql)
	if up==True:
		db.commit()
		cursor.close()
	else:
		data=cursor.fetchone()
		cursor.close()
		return data

def getauthkey(msgid):
    mdid=hashlib.md5()
    mauth=hashlib.md5()
    mauthstr=hashlib.md5()
    mdid.update(did.encode(encoding='utf-8'))
    mauth.update(authkey.encode(encoding='utf-8'))
    mstr=mdid.hexdigest()+str(msgid)+mauth.hexdigest()
    mauthstr.update(mstr.encode(encoding='utf-8'))
    return mauthstr.hexdigest()

def init():
	if newadb.is_screenon()==False:
		keyevent('26')
	if newadb.is_locked()==True:
		newadb.unlock()
	start_app('com.unionpay')
	start_app('com.unionpay','activity.UPActivityMain')
	sleep(2)

def getorder():
	try:
		r=requests.get('http://'+serverip+'/api/msg/order?did='+serial)
		if (r.status_code == 200) and (r.text !=0):
			order=r.text
			data=eval(order)
		else:
			print('没有查到待付的订单')
			data=0;
	except Exception as e:
		print('请检查订单接口')
		data=0
	return data

def getbal():
	init()
	if (poco(text="卡管理").exists()==True):
		poco(text="卡管理").click()
	for i in range(1,60):
		if (poco(text="****").exists()==True):
			poco("android:id/content").child("android.widget.FrameLayout").child("android.widget.FrameLayout").child("android.view.ViewGroup").child("android.view.ViewGroup").child("android.view.ViewGroup").child("android.view.ViewGroup")[1].child("android.view.ViewGroup").offspring("android.widget.ScrollView").child("android.view.ViewGroup").child("android.view.ViewGroup")[1].child("android.view.ViewGroup").child("android.view.ViewGroup")[0].child("android.view.ViewGroup").offspring("android.widget.ImageView")[0].click()
			break
		sleep(1)
	
	bal=poco("android:id/content").child("android.widget.FrameLayout").child("android.widget.FrameLayout").child("android.view.ViewGroup").child("android.view.ViewGroup").child("android.view.ViewGroup").child("android.view.ViewGroup")[1].child("android.view.ViewGroup").offspring("android.widget.ScrollView").child("android.view.ViewGroup").child("android.view.ViewGroup")[1].child("android.view.ViewGroup").child("android.view.ViewGroup")[0].child("android.view.ViewGroup").child("android.widget.TextView")[1].get_text()

	balance=bal.replace(',','')
	sub_time=str(int(time.time()))
	info='{"aid":"'+aid+'","bal":"'+balance+'","sub_time":"'+sub_time+'"}}'
	msgid=str(getmsgid())
	auth=getauthkey(msgid)
	data='{"name":"Yunshan","type":"bal","msgid":"'+msgid+'","id":"'+did+'","auth":"'+auth+'","data":'+info
	cmd="curl -d '"+data+"' -s http://"+serverip+"/api/msg/bal"
	os.system(cmd)

def	createOrder(order):
	step=0;
	if (poco(text="收款码").exists()==True):
		step=1
		poco(text="收款码").click()
	if (poco(text="清除金额").exists()==True):
		step=2
		poco(text="清除金额").click()
	if (poco(text="设置金额").exists()==True):
		step=3
		poco(text="设置金额").click()
	if step==0:
		init()
		sleep(1)
		poco(text="收款码").click()
		poco(text="设置金额").click()
	
	poco(text="请输入收款金额").set_text(order['amount'])
	poco(text="20字以内（可不填）").set_text(order['m_trade_no'])
	poco("com.unionpay:id/btn_set_amount_confirm").click()

def	getpaystate(order):
	paid=False
	amount='0'
	for i in range(1,180):
		if paid==False:
			paid=poco("android:id/content").offspring("com.unionpay:id/frag_qr_code_in").offspring("com.unionpay:id/scrollview").offspring("com.unionpay:id/lv_p2ptransfer_payer").child("android.widget.LinearLayout").offspring("com.unionpay:id/tv_p2ppay_all_amount").exists()
			if paid==True:
				amount=poco("android:id/content").offspring("com.unionpay:id/frag_qr_code_in").offspring("com.unionpay:id/scrollview").offspring("com.unionpay:id/lv_p2ptransfer_payer").child("android.widget.LinearLayout").offspring("com.unionpay:id/tv_p2ppay_all_amount").get_text()
				if(amount.replace('\xa5','')==order['amount']):
					upsql="UPDATE `order` SET `pay_state`=%d, `step`= %d WHERE `id`= %s;" % (1,3,order['id'])
					opsql(upsql,1,up=True)
					if (poco(text="清除金额").exists()==True):
						poco(text="清除金额").click()
					return 1
		sleep(1)
	return 0

def getQR():
    os.system('adb -s '+serial+' shell screencap -p > '+qr);

def decodeQR(orderId):
	zbar = zxing.BarCodeReader()
	qrinfo = zbar.decode(qr)
	qrcode=qrinfo.parsed
	upsql="UPDATE `order` SET `pay_qrcode`='%s', `step`= %d WHERE m_trade_no= '%s';" % (qrcode,3,orderId)
	opsql(upsql,1,up=True)

def openMerchant():
	if (poco(text="收款明细").exists()==False):
		init()
		poco(text="收款码").click()
		poco(text="商户收款").click()
		for i in range(1,60):
			if poco(text="收款记录").exists()==True:
				break
			sleep(1)
		poco(text="收款记录").click()
	# 为刷新页面
	poco(text="最近3天").click()
	sleep(1)
	# 防止00点分页的特殊处理。服务端同样处理
	time_int=int(time.time())
	t=time.strftime('%H%M%S', time.localtime(time_int))
	if (t>'000010'):
		poco(text="今天").click()
	sleep(2)
	
# 付款凭证号：31191125862881008231 账户卡号：6217****6674 金额：2.00元 2019/11/26 00:00:47 
def checkMerchatOrderInfo():
	time_int=int(time.time())
	t=time.strftime('%H%M%S', time.localtime(time_int))
	if (t<'000011'):
		maxno=int(10)
	else:
		maxno=int(1000)

	for i in range(5,maxno):
		info=''
		orderinfo=poco("com.unionpay:id/view_content_container").child("android.webkit.WebView").offspring("app").child("android.view.View")[1].child("android.view.View")[i].get_text()
		if orderinfo=="暂无更多数据~~":
			break
		info=orderinfo.replace(' ','').replace('付款凭证号：','{"payid":"').replace('账户卡号：','","payorAccount":"').replace('金额：','","amount":"').replace('元','","paytime":"')
		info+='","aid":"'+aid+'"}'	
		orderdata=eval(info)
		sql="SELECT `state` FROM `order` WHERE `oid`='%s';" % (orderdata['payid'])
		orderstate=opsql(sql,2)
		if (orderstate is None) or (orderstate !=1):
			time_int=str(int(time.time()))
			msgid=str(getmsgid())
			auth=getauthkey(msgid)
			data=str('{"id":"'+did+'", "auth": "'+auth+'", "name": "Yunshan", "type": "notice", "msgid": "'+msgid+'", "sub_time": "'+time_int+'","data":'+info+'}')
			r=requests.post('http://'+serverip+'/api/msg/index',data=data)
			if (r.status_code == 200) and (r.text ==1):
				ostate=1
			else:
				ostate=0

			insertsql="INSERT INTO `order` ('oid','state')  VALUES ('%s','%s')" % (orderdata['payid'],ostate)
			opsql(insertsql,2,True)


def getmsgid():
	time_int=int(time.time())
	msgid=time_int-1500000000
	return msgid

# 初始化数据变量
def devready():
	createsql='CREATE TABLE IF NOT EXISTS "order"("oid" Text,"state" Boolean DEFAULT 0 );'
	newtable=opsql(createsql,2)
	indexsql='CREATE INDEX IF NOT EXISTS "index_oid" ON "order"("oid");'
	newtable=opsql(indexsql,2)
	cfgsql="SELECT `id`,`aid`,`authkey` FROM `device` WHERE `serial`='%s';" % (serial)
	cfginfo=opsql(cfgsql)
	global did,aid,authkey
	did=str(cfginfo[0])
	aid=str(cfginfo[1])
	authkey=str(cfginfo[2])


# sleep(1000)
devready()
start_app('com.unionpay','activity.UPActivityMain')
while 1==1:
	now_time=int(time.time()) 
	t=time.strftime('%H%M', time.localtime(now_time))
	# 分时段23-09商户其他时间个人码收款
	if (t>'2259') or (t<'0900'):
		# 进入商户查询页面
		openMerchant()
		# 开始查收款，商户是固定码服务端会直接返回后续加入初始化功能
		checkMerchatOrderInfo()
	else:
		#1 获取待付订单信息
		order=getorder()
		# print(order)
		#2 有订单就处理
		if (order != 0):
			# 创建收款订单
			createOrder(order)
			# 获取收款二维码
			getQR()
			# 解析成url
			decodeQR(order['m_trade_no'])
			# 查看收款成功状态，含超时自动清理
			if (getpaystate(order)==1):
				# 收到钱就查余额
				getbal()
		else:
			#3 没有订单就休息15秒
			sleep(5)
	sleep(10)

