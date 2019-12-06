# -*- encoding=utf8 -*-
__author__ = "elon"

import time

import pymysql
import requests
import sys
import hashlib

from airtest.core.api import *
from
from poco.drivers.android.uiautomation import AndroidUiautomationPoco
poco = AndroidUiautomationPoco(use_airtest_input=True, screenshot_each_action=False)

auto_setup(__file__)
start_app('com.unionpay')
# print(a)
# sleep(30)

# args=sys.argv[4]
# serial=args.replace('Android:///','')
# qrpath="/Users/elon/pandapayMobile/"

# def opsql(sql,up=False):
# 	db = pymysql.connect("127.0.0.1","root","pwd123!@#","pandapay")
# 	cursor = db.cursor()	 
# 	cursor.execute(sql)
# 	if up==True:
# 		db.commit()
# 		cursor.close()
# 	else:
# 		cursor.close()
# 		return cursor.fetchone()

# def init():
# 	start_app('com.unionpay')
# 	start_app('com.unionpay','activity.UPActivityMain')
# 	sleep(2)
# def getorder():
# 	try:
# 		r=requests.get('http://pay.com/api/msg/order?did='+serial)
# 		print(r.status_code)
# 		if (r.status_code == 200) and (r.text !=0):
# 			order=r.text
# 			data=eval(order)
# 			print(data)
# 		else:
# 			print('没有查到待付的订单')
# 			data=0;
# 	except Exception as e:
# 		print('检查接口')
# 		data=0
# 	return data

# # def getorder():
# # 	db = pymysql.connect("127.0.0.1","root","pwd123!@#","pandapay")
# # 	cursor = db.cursor()	 
# # 	sql="SELECT `id`,`m_trade_no`,`amount` FROM `order` WHERE `step`=1 LIMIT 1 FOR UPDATE;"
# # 	try:
# # 		cursor.execute(sql)
# # 		data = cursor.fetchone()
# # 		if(type(data) == type(("id","m_trade_no","amount"))):
# # 			upsql="UPDATE `order` SET `step`=2 WHERE `id`= %s " % (data[0])
# # 			cursor.execute(upsql)
# # 		else:
# # 			print('没有查到待付的订单')
# # 			data=0;
# # 	except Exception as e:
# # 		db.rollback()	
# # 	else:
# # 		db.commit()
# # 	finally:
# # 		db.close()
# # 	return str(data)

# def getbal():
# 	init()
# 	# poco("com.unionpay:id/forthItem").wait().click()
# 	poco(text="卡管理").wait().click()
# 	sub_time=str(int(time.time()))
# 	sleep(2)
# 	bal=poco("android:id/content").child("android.widget.FrameLayout").child("android.widget.FrameLayout").child("android.view.ViewGroup").child("android.view.ViewGroup").child("android.view.ViewGroup").child("android.view.ViewGroup")[1].child("android.view.ViewGroup").offspring("android.widget.ScrollView").child("android.view.ViewGroup").child("android.view.ViewGroup")[1].child("android.view.ViewGroup").child("android.view.ViewGroup")[0].child("android.view.ViewGroup").child("android.widget.TextView")[1].get_text()
# 	balance=bal.replace(',','')
# 	data='{"name":"Yunshan","did":"'+serial+'","bal","'+balance+'","time":"'+sub_time+'"}'
# 	# print(data)
# 	os.system('curl -d "{$data}" -s http://pay.com/api/msg/bal')


# def	createOrder(order):
# 	step=0;
# 	if (poco(text="收款码").exists()==True):
# 		step=1
# 		poco(text="收款码").click()
# 	if (poco(text="清除金额").exists()==True):
# 		step=2
# 		poco(text="清除金额").click()
# 	if (poco(text="设置金额").exists()==True):
# 		step=3
# 		poco(text="设置金额").click()
# 	if step==0:
# 		init()
# 		sleep(1)
# 		poco(text="收款码").click()
# 		poco(text="清除金额").click()
# 		poco(text="设置金额").click()

# 	# poco(text="收款记录").click()
# 	poco(text="请输入收款金额").set_text(order[2])
# 	poco(text="20字以内（可不填）").set_text(order[1])
# 	poco("com.unionpay:id/btn_set_amount_confirm").click()

# def	getpaystate(order):
# 	paid=False
# 	amount='0'
# 	for i in range(1,175):
# 		if paid==False:
# 			paid=poco("android:id/content").offspring("com.unionpay:id/frag_qr_code_in").offspring("com.unionpay:id/scrollview").offspring("com.unionpay:id/lv_p2ptransfer_payer").child("android.widget.LinearLayout").offspring("com.unionpay:id/tv_p2ppay_all_amount").exists()
# 			if paid==True:
# 				amount=poco("android:id/content").offspring("com.unionpay:id/frag_qr_code_in").offspring("com.unionpay:id/scrollview").offspring("com.unionpay:id/lv_p2ptransfer_payer").child("android.widget.LinearLayout").offspring("com.unionpay:id/tv_p2ppay_all_amount").get_text()
# 				if(amount.replace('\xa5','')==order[2]):
# 					upsql="UPDATE `order` SET `pay_state`=%d, `step`= %d WHERE `id`= %s;" % (1,3,order[0])
# 					opsql(upsql,up=True)
# 					poco(text="清除金额").click()
# 					return 1
# 		sleep(1)
# 	return 0

# def getQR(name):
#     screencap="/Users/elon/pandapayMobile/"+name+".png";
#     os.system('adb shell screencap -p > '+screencap);

# def decodeQR(orderId):
# 	# qrcode=os.popen("/usr/local/bin/spanner -s "+qrpath+orderId+".png").readline()
# 	qrcode=os.popen("/usr/local/bin/spanner -s /Users/elon/pm/paystudy/pingan.jpg").readline()
# 	upsql="UPDATE `order` SET `pay_qrcode`='%s', `step`= %d WHERE m_trade_no= '%s';" % (qrcode,3,orderId)
# 	opsql(upsql,up=True)

# # init()
# while 1==1:
# 	order=getorder()
# 	# print(order)
# 	if(order != 0):
# 		# 上报自己进入收款状态
# 		# os.system('curl -s http://pay.com/api/msg/pending?did='+serial+'&state=1')
# 		createOrder(order)
# 		getQR(order[1])
# 		decodeQR(order[1])
# 		getpaystate(order)
# 		# os.system('curl -s http://pay.com/api/msg/pending?did='+serial+'&state=0')
# 		# if (getpaystate(order[2])==1):
# 			# getbal()
# 	sleep(5)


