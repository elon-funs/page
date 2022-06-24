<?php

namespace app\common\command;

use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\input\Option;
use think\console\Output;
use app\common\command\Redis;
// use think\cache\Driver\Redis;
use think\Db;

class UserTree extends Command
{
    protected function configure()
    {
        // 指令配置
        $this->setName('usertree')
            ->setDescription('会员代理树初化更新');
    }

    protected function execute(Input $input, Output $output)
    {
        echo 'start'.PHP_EOL;
        $this->modifyTable();
        $this->format_users();
    }

    public function modifyTable()
    {
        try {
            $sql='';
            $sql='drop table if exists xy_user_tree;';
            DB::execute($sql);
            echo '删除user_tree数据表'.PHP_EOL;

            $sql='';
            $sql='
            CREATE TABLE `xy_user_tree`( 
                `id` Int( 10 ) UNSIGNED AUTO_INCREMENT NOT NULL,
                `user_id` Int( 11 ) UNSIGNED NOT NULL DEFAULT 0,
                `parent_id` Int( 11 ) UNSIGNED NOT NULL DEFAULT 0,
                `path` TEXT,
                `level` TinyInt( 1 ) UNSIGNED NOT NULL DEFAULT 0,
                `is_jia` TinyInt( 1 ) NOT NULL DEFAULT 0,
                `update_at` Timestamp NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY ( `id` ),
                CONSTRAINT `user_id` UNIQUE( `user_id` ) )
            CHARACTER SET = utf8mb4
            COLLATE = utf8mb4_general_ci
            COMMENT "用户树"
            ENGINE = InnoDB
            AUTO_INCREMENT = 1;';
            DB::execute($sql);
            echo '建表'.PHP_EOL;
     
        } catch (Exception $e) {
            var_dump($e->getMessage());
        }
    }

    public function create_index()
    {
            $sql='';
            $sql='CREATE INDEX `Index_1` USING BTREE ON `xy_user_tree`( `is_jia` );';
            DB::execute($sql);
            
            $sql='';
            $sql='CREATE INDEX `Index_2` USING BTREE ON `xy_user_tree`( `parent_id` );';
            DB::execute($sql);

            $sql='';
            $sql='CREATE INDEX `Index_3` USING BTREE ON `xy_user_tree`( `user_id` );';
            DB::execute($sql);

            $sql='';
            $sql='CREATE INDEX `Index_4` USING BTREE ON `xy_user_tree`( `level` );';
            DB::execute($sql);

            $sql='';
            $sql='CREATE INDEX `Index_6` USING BTREE ON `xy_user_tree`( `update_at` );';
            DB::execute($sql);
            echo '增加索引'.PHP_EOL;  
    }

    public function format_users()
    {   
        $sql='';
        $sql="INSERT INTO xy_user_tree(`user_id`,`parent_id`,`is_jia`) select `id` as `user_id`,`parent_id`,`is_jia` from xy_users where `id`>=1 order by `id` asc";
        DB::execute($sql);
        echo '把用户表中的数据加入tree表'.PHP_EOL;
        $sql='';
        $sql="update xy_user_tree set `path`='0',`level`=1 where parent_id=0 and level<1";
        DB::execute($sql);
        echo '最顶级用户加入tree表'.PHP_EOL;
        // exit();

        for ($i=1; $i < 2000; $i++) { 
            $sql='';
            $sql="update xy_user_tree as a,xy_user_tree as b set `a`.`path`=concat(`b`.`path`,'>',a.`parent_id`),a.`level`=b.`level`+1 where a.parent_id=b.user_id and a.level<1 and b.level=".$i.";";
            $a=DB::execute($sql);
            echo 'updated'.$a.'rows'.PHP_EOL;
            if ($a<1) {
                $this->create_index();
                echo '全部完成'.PHP_EOL;
                exit();
            }
        }
    
    }

    public function add_agent_line_every_user()
    {
        // 共分3步完成
        //1把所有代理加入树表
        $agentsql="INSERT INTO xy_user_tree(`user_id`,`parent_id`,`tree_id`,`level`) select `id` as `user_id`,`parent_id`,`id` as `tree_id`,1 from xy_users where xy_users.user_sign=2";
        DB::execute($agentsql);
        //2普通代理加入树表
        $sonsql="INSERT INTO xy_user_tree(`user_id`,`parent_id`) select `id` as `user_id`,`parent_id` from xy_users where xy_users.user_sign=1";
        DB::execute($sonsql);

        //3从树根开始赋值,tree_id与父辈相同,level比父辈+1
        for ($i=1; $i < 2000; $i++) { 
            $upsql="update xy_user_tree as a,xy_user_tree as b set `a`.`tree_id`=`b`.`tree_id`,a.`level`=b.`level`+1 where a.parent_id=b.user_id and a.level<1 and b.level=".$i.";";
            $a=DB::execute($upsql);
            echo 'updated'.$a.'rows'.PHP_EOL;
            if ($a<1) {
                $this->create_index();
                echo '全部完成'.PHP_EOL;
                exit();
            }
        }
    }

}


