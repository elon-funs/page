<?php

namespace app\common\command;

use think\console\Command;
use think\console\input\Argument;
use think\console\Input;
use think\console\Output;
use think\Db;

class Upgrade extends Command
{
    protected $table='system_upgrade';
    protected $database='sd_testfbd_com';

    protected function configure()
    {
        // 指令配置
        $this->setName('Upgrade')
            ->addArgument('fname', Argument::OPTIONAL, "单独指定方法")
            ->setDescription('代码升级');
    }

    protected function execute(Input $input, Output $output)
    {
        $this->init();
        //1获取本类中所有方法
        $allfuncs=get_class_methods($this);
        $fname = trim($input->getArgument('fname'));
        
        //2指定方法名,则单独执行并更新或插入记录
        if (''!=$fname and !empty($fname)) {
            $has=array_search($fname, $allfuncs);
            if (!$has) exit("方法名不存在--请确认参数名");
            $this->single($fname);
        }else{
        //3无指定方法则检查并执行本文件中的所有未执行方法，并写入新记录
            $this->check($allfuncs);
        }
    }
    public function init()
    { 
        $tables=DB::query('show tables');
        $inited=array_search('system_upgrade',array_column($tables,'Tables_in_sd_testfbd_com'));
        if (false == $inited) {
            $sql='';
            $sql='drop table if exists system_upgrade;';
            DB::execute($sql);
            echo '如有删除system_upgrade数据表'.PHP_EOL;

            $sql="CREATE TABLE system_upgrade( 
                `id` Int( 10 ) UNSIGNED AUTO_INCREMENT NOT NULL,
                `action_num` TinyInt( 1 ) NOT NULL DEFAULT 1,
                `func_name` VarChar( 200 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                `func_desc` VarChar( 255 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
                `start_at` DateTime NOT NULL,
                `done_at` DateTime NOT NULL,
                `status` TinyInt( 1 ) NOT NULL DEFAULT 1 COMMENT '1成功0失败',
                PRIMARY KEY ( `id` ) )
            CHARACTER SET = utf8mb4
            COLLATE = utf8mb4_general_ci
            COMMENT '升级脚本表记录'
            ENGINE = InnoDB
            AUTO_INCREMENT = 1;";
            DB::execute($sql);
            
            $sql='';
            $sql='CREATE INDEX `index_actions_num` USING BTREE ON `system_upgrade`( `action_num` )';
            DB::execute($sql);

            $sql='';
            $sql='CREATE INDEX `index_class_name` USING BTREE ON `system_upgrade`( `func_name` )';
            DB::execute($sql);
            echo '建表完成'.PHP_EOL;

            $allfuncs=get_class_methods($this);
            $data=[];
            foreach ($allfuncs as $k=>$value) {
                $data[$k]['start_at']=date('Y-m-d H:i:s');
                $data[$k]['done_at']=date('Y-m-d H:i:s');
                $data[$k]['func_name']=$value;
            }
            Db::name($this->table)->data($data)->insertAll();
            echo '本类方法全部写入数据库,标记为已完成'.PHP_EOL;
        }
    }

    public function single($dofunc)
    {
        $did=DB::name($this->table)->where('func_name',$dofunc)->find();
        $action_num=1;
        if (is_array($did) and !empty($did)){
            echo "方法:[ ".$did['func_name']." ]在".$did['done_at']."-已执行过第[ ".$did['action_num']." ]次,ctrl+c取消本次操作".PHP_EOL;
            sleep(3);
            echo "将在5秒内执行.........".PHP_EOL;
            sleep(3);
            echo "将在2秒内执行....".PHP_EOL;
            sleep(2);
            echo "开始执行.".PHP_EOL;
            $action_num=($did['action_num']+1);
        }
        $start_at=date('Y-m-d H:i:s');
        $funcdesc=$this->$dofunc();
        $done_at=date('Y-m-d H:i:s');
        $data=[
            'func_name'=>$dofunc,
            'func_desc'=>$funcdesc,
            'status'=>1,
            'start_at'=>$start_at,
            'done_at'=>$done_at,
            'action_num'=>$action_num,
        ];
        if (is_array($did) and !empty($did)){
            DB::name($this->table)->where('id',$did['id'])->update($data);
        }else{
            DB::name($this->table)->insert($data);
        }
    }

    public function check($allfuncs)
    {
        $data=[];
        $donefuncs=DB::name($this->table)->where('status',1)->column('func_name');
        $newfuncs=array_diff($allfuncs, $donefuncs);
        if(is_array($newfuncs)) 
            foreach ($newfuncs as $v){
                $start_at=date('Y-m-d H:i:s');
                $this->$v(); 
                $done_at=date('Y-m-d H:i:s');
                DB::name($this->table)->insert([
                    'func_name'=>$v,
                    'status'=>1,
                    'start_at'=>$start_at,
                    'done_at'=>$done_at,
                    'action_num'=>1
                ]);
                echo '方法:[ '.$v.' ]执行完成'.PHP_EOL;
            } 
    }

    public function test()
    {
        echo 9999;
    }
}


