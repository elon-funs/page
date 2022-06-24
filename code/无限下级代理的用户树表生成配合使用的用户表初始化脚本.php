<?php

namespace app\common\command;

use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\input\Option;
use think\console\Output;
use think\Db;

class userFormat extends Command
{
    protected function configure()
    {
        // 指令配置
        $this->setName('UserFormat')
            ->setDescription('会员表数据归正,结构为1个id0>1个id1>多个任意会员');
    }

    protected function execute(Input $input, Output $output)
    {
        echo 'start'.PHP_EOL;
        $this->format_users();
    }

    public function format_users()
    {
        try {
            $total=DB::name('xy_users')->count(1);
            echo 'users表当前总共[ '.$total.' ]条数据'.PHP_EOL;
            
            $p0=DB::name('xy_users')->where('parent_id',0)->count(1);
            if ($p0>1) {
                echo '!!error~~当前有[ '.$p0.' ]parent_id=0的会员'.PHP_EOL;
                sleep(2);
                echo '系统将他们全部转入id=1的下级！！'.PHP_EOL;
                sleep(2);
                echo '如有请后台手动可以再调整转移代理';
                sleep(2);
                DB::name('xy_users')->where('parent_id',0)->where('id','>',1)->update(['parent_id'=>1]);
            }

            echo '全部会员childs设置为0'.PHP_EOL;
            for ($i=1; $i < $total; $i+=5000) { 
                DB::name('xy_users')->where('id','between',[$i,$i+5000])->update(['childs'=>0]);
            }
            $childs=DB::name('xy_users')->field('parent_id as id, count(1) as childs')->where('parent_id','>',0)->group('parent_id')->select();
            $ids=implode(',',array_column($childs, 'id'));
            $upsql = 'UPDATE `xy_users` SET `childs`= CASE `id` ';
            foreach ($childs as $son) 
                $upsql .= ' WHEN '.$son['id'].' THEN '.$son['childs'];

            $upsql.=' END WHERE ID IN ('.$ids.');';
            // echo $upsql.PHP_EOL;
            $done=DB::execute($upsql);

            echo '父类统计[ '.$done.'　]条数据'.PHP_EOL;
            echo '全部完成'.PHP_EOL;
        } catch (Exception $e) {
            var_dump($e->getMessage());
        }
    }

}


