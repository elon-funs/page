<?php
/**
 * 
 *　短信验证码
 *  有申请总数限止
 *  有间隔时长限止
 *  有验证有效期限止
 *  有场景/接口限止
 * 　有国际国内分别
 * business_申请的场景或者接口
 * device_id　手机设备ID
 * mobile 手机号
 * code 验证码
 * cool_冷却间隔时长
*/

namespace app\login\controller;

use app\common\service\AliyunSMS;
use app\common\service\IPGOSMS;
use Exception;
use Redis;
use think\facade\Request;
use think\facade\Log;

class MobileLogin
{
    const SMS_BUSINESS_BIND = 1;//绑定手机
    const SMS_BUSINESS_LOGIN = 2;//登录
    const SMS_BUSINESS_RESET = 3;//重置密码
    const SMS_BUSINESS_DEL = 4;  //手机解绑
    const SMS_SEND_COOL_SECONDS = 120; //验证码间隔时间
    const SMS_VERIFY_MAX_NUM = 5;//连续验错5次

    private function verifySMSCode($device_id, $business, $mobile, $code)
    {
        if (!$code) return false;
        
        $redis = new Redis();
        $redis->connect(config('redis.host'), config('redis.port'));
        $key = self::getSMSRedisKey($device_id,$business,$mobile);
        $codeExcepted = $redis->get($key);
        
        Log::info(['$codeExcepted'=>$codeExcepted,'key'=>$key,'$code'=>$code]);
        
        $countKey = self::getSMSRedisKey($device_id,$business,'count');
        $current = $redis->incrBy($countKey, 1);
        if ($current >= SMS_VERIFY_MAX_NUM) return false;
        return $codeExcepted === $code;
    }

    
    //发送验证码
    private function sendSMSCode($device_id, $business, $mobile, $is_global = false)
    {   
        $key = self::getSMSRedisKey($device_id,$business,$mobile);
        $cool_key = self::getSMSRedisKey($device_id,$business,'cool');
        $redis = new Redis();
        $redis->connect(config('redis.host'), config('redis.port'));
        if (!$redis->setnx($cool_key, 1)) throw new Exception('发送太频繁',7017);
        $redis->expire($cool_key, self::SMS_SEND_COOL_SECONDS);
        $code = mt_rand(10000,999999);
        $sms_code_expire = self::SMS_SEND_COOL_SECONDS * 2;
        Log::info(['$key'=>$key,'code'=>$code]);
        $redis->set($key, $code , $sms_code_expire);
        $redis->set(self::getSMSRedisKey($device_id, $business,'count'), 0, $sms_code_expire);
        $redis->close();
        if ($is_global) return AliyunSMS::send($mobile, $code);
        return IPGOSMS::send('00'.$mobile,$code);
    }

    private static function getSMSRedisKey($device_id,$business,$mobile)
    {
        $device_id = md5($device_id);
        return "sms:{$device_id}:{$business}:{$mobile}";
    }

}