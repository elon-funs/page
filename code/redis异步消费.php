<?php

namespace app\common\command;

use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\input\Option;
use think\console\Output;
// use app\common\command\Redis;
use think\cache\Driver\Redis;
use think\Db;

class Statistic extends Command
{
    //场景说明
    protected $sence=[0=>'init',1=>'register',2=>'login',3=>'recharge',4=>'withdraw',5=>'orders',6=>'bonus','7'=>'update'];

    //失败时尝试次数
    protected $tries=3;

    //每次处理的redis条数
    protected $batch=30;

    // 没数据时休息秒数
    protected $sleep=30;


    protected function configure()
    {
        // 指令配置
        $this->setName('Statistic')
            ->setDescription('异步动态统计平台报表数据');
    }

    protected function execute(Input $input, Output $output)
    {
        $this->work();
    }
    

    protected function work()
    {   
        // 1从redis,取数据然后再放入，处理中队列并计数＋1，以防止失败
        $redis=new Redis();
        $len=$redis->xlen('mystream');
        $data=$redis->XRANGE('mystream','-','+',$this->batch);
        // $data=$redis->XRANGE('mystream','1648316863380','1648317214780');
        // $data=$redis->XACK('mystream','1648316863380');
        // var_dump($data);
        // if (empty($data)) sleep($this->sleep);
        $updata=[];

        // 2依不同场景将数据归整　
        foreach ($data as $rows) {
            foreach ($rows as $row) {
                $updata[$row['sence']][]=$row['body'];
            }
        }

        // 3针对每个场景批量更新。
        foreach ($updata as $sence=>$body) {
            $fname=$this->sence[$sence];
            $this->$fname($body);
        }

        // 4在成功处理完后删除redis数据
        // $data=$redis->Xdel('mystream','1648316863380');

    }

    //注册后增加新会员
    public function register($data)
    {
        $ids=[];
        $ids=array_column($data,'id');
        DB::name('xy_statistics')->where('uid','in',$ids)->update($data);
    }
    
}


