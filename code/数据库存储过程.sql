select `name` from mysql.proc where db = 'sd_testfbd_com' and `type` = 'PROCEDURE' 
show procedure status; 
show create procedure get_report_Infinite_level

DROP PROCEDURE  IF EXISTS sd_testfbd_com.get_user_tree_vtable_235;


delimiter $$$
CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_childs_by_user_tree`(IN `pid` int,OUT `finalVarEnd` LONGTEXT,OUT `total_num` int)
BEGIN
set @pid=pid;

-- id0下级是全部,如果全平台只有一个总监id1也走这个
IF pid < 2 THEN
    SELECT GROUP_CONCAT(user_id) INTO finalVarEnd FROM xy_user_tree WHERE is_jia=0;
    SELECT COUNT(1) into total_num FROM xy_user_tree WHERE is_jia=0;
ELSE
    -- //无下级的下级 union //有下级的下级
    set @idssql="(select user_id from xy_user_tree where path=(select concat(`path`,'>',`user_id`) from xy_user_tree where user_id=@pid) and is_jia=0
    union
    select user_id as ids from xy_user_tree where path like (select concat(`path`,'>',`user_id`,'>%') from xy_user_tree where user_id=@pid) and is_jia=0) ids";
    SET @sql = concat('SELECT GROUP_CONCAT(user_id) INTO @finalVarEnd FROM ',@idssql);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;  
    deallocate prepare stmt;
    SET finalVarEnd = @finalVarEnd;
    
    SET @sql = concat('SELECT COUNT(1) INTO @total_num FROM ',@idssql);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;  
    deallocate prepare stmt;
    SET total_num = @total_num;
END IF;
END;
-- -------------------------------------------------------------

$$$ delimiter ;

DROP PROCEDURE sd_testfbd_com.get_report_Infinite_level;
delimiter $$$ 
-- -------------------------------------------------------------

CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_report_Infinite_level`(IN `pid` INT,
    OUT `renshu` INT,
    OUT `charge` FLOAT,
    OUT `tixian` FLOAT,
    OUT `promos` FLOAT,
    OUT `ordermoney` FLOAT,
    OUT `yongjin` FLOAT,
    OUT `balance` FLOAT,
    OUT `prize` FLOAT,  
    OUT `rihuo` INT,
    OUT `depositnow` FLOAT,
    OUT `zongcunchu` FLOAT,
    OUT `youxiaoadd` INT)
BEGIN
# 功能：后台调用的团队报表（不限下级）
# 修改人：Jessica
# 修改时间：2022-3-28
DECLARE v_table_column LONGTEXT;
DECLARE allsonids LONGTEXT;
CALL get_childs_by_user_tree(pid,@finalVarEnd,@totalnum);
#查询人数
SET renshu=@totalnum;
#获取所有子级人数
SELECT @finalVarEnd INTO @newData;
SET allsonids=@newData;
#获取相关汇总数据
SET charge=0;
SET tixian=0;
SET promos=0;
SET ordermoney=0;
SET yongjin=0;
SET balance=0;
SET prize=0;
SET rihuo=0;
SET depositnow=0;
SET zongcunchu=0;
SET youxiaoadd=0;
IF renshu>0 THEN
#查询充值
SELECT SUM(r.num) INTO charge FROM xy_recharge r  where r.status=2 and FIND_IN_SET(r.uid,allsonids);
#查询提现       
SELECT SUM(d.num) INTO tixian FROM xy_deposit d  where d.status=2 and FIND_IN_SET(d.uid,allsonids);
#查询提现中
SELECT SUM(d.num) INTO depositnow FROM xy_deposit d  where d.status=1 and FIND_IN_SET(d.uid,allsonids);
#查询系统赠送
SELECT SUM(b.num) INTO promos FROM xy_balance_log b  where b.type=0 and FIND_IN_SET(b.uid,allsonids);
#查询流水
SELECT SUM(c.num) INTO ordermoney FROM xy_convey c  where c.status=1 and FIND_IN_SET(c.uid,allsonids);
#查询佣金
SELECT SUM(o.commission) INTO yongjin FROM xy_convey o  where o.status=1 and FIND_IN_SET(o.uid,allsonids);
#查询下级总余额
SELECT SUM(u.balance) INTO balance FROM xy_users u  where u.status=1 and FIND_IN_SET(u.id,allsonids);
#查询下级返佣
SELECT SUM(r.num) INTO prize FROM xy_reward_log r where r.sid=pid and r.status=2 and r.type=2;
#查询下级活跃人数
SELECT count(1) INTO rihuo FROM (SELECT uid from (SELECT DISTINCT(c.uid) FROM xy_convey c  where c.status=1 union select DISTINCT(r.uid) from xy_recharge r where r.status=2 and r.uid not in(SELECT DISTINCT(x.uid) FROM xy_convey x where x.status=1)) a where FIND_IN_SET(a.uid,allsonids)) b;
#查询余额宝总存储
SELECT SUM(a.num) INTO zongcunchu FROM xy_lixibao a  where a.is_qu=0 and FIND_IN_SET(a.uid,allsonids);
#查询下级有效新增
select count(1) INTO youxiaoadd from (SELECT id from xy_users where isvalid=1 and FIND_IN_SET(id,allsonids)) a;
 END IF;
END
-- -------------------------------------------------------------

$$$ delimiter ;



delimiter $$$ 
-- CREATE FUNCTION "get_child_userfor" -------------------------
CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_childs_by_user_tree`(IN `pid` int,OUT `finalVarEnd` LONGTEXT,OUT `total_num` int)
BEGIN

DECLARE finalVar LONGTEXT;
set @pid=pid;

-- id0下级是全部,如果全平台只有一个总监id1也走这个
IF pid < 2 THEN
    SELECT GROUP_CONCAT(user_id) INTO finalVarEnd FROM xy_user_tree WHERE is_jia=0;
    SELECT COUNT(1) into total_num FROM xy_user_tree WHERE is_jia=0;
ELSE
    -- //无下级的下级 union //有下级的下级
    set @idssql="(select user_id from xy_user_tree where path=(select concat(`path`,'>',`user_id`) from xy_user_tree where user_id=@pid) and is_jia=0
    union
    select user_id as ids from xy_user_tree where path like (select concat(`path`,'>',`user_id`,'>%') from xy_user_tree where user_id=@pid) and is_jia=0) ids";
    SET @sql = concat('SELECT GROUP_CONCAT(user_id) INTO @finalVarEnd FROM ',@idssql);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;  
    deallocate prepare stmt;
    SET finalVarEnd = @finalVarEnd;
    
    SET @sql = concat('SELECT COUNT(1) INTO @total_num FROM ',@idssql);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;  
    deallocate prepare stmt;
    SET total_num = @total_num;
END IF;
END
END;
-- -------------------------------------------------------------

$$$ delimiter ;



delimiter $$$ 
-- CREATE FUNCTION "get_child_userfor" -------------------------
CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_childs_by_user_tree`(IN `pid` int,OUT `finalVarEnd` LONGTEXT,OUT `total_num` int)
BEGIN
DECLARE finalVar LONGTEXT;
DECLARE tempVar LONGTEXT;
DECLARE vcount INT;

SET finalVar=0;
SET vcount=0;
SET total_num=0;
 
-- id0下级是全部,如果全平台只有一个总监id1也走这个
IF pid < 2 THEN
    SELECT GROUP_CONCAT(t.id) INTO finalVarEnd FROM xy_user_tree WHERE  id>0 and is_jia=0;
ELSE
    -- //无下级的下级 union //有下级的下级
    set @sql=select GROUP_CONCAT(user_id) INTO finalVarEnd COUNT(1) INTO total_num from (select user_id from xy_user_tree where path= (select concat(`path`,'>',`user_id`) from xy_user_tree where user_id=17) and is_jia=0
    union
    select user_id as ids from xy_user_tree where path like (select concat(`path`,'>',`user_id`,'>%') from xy_user_tree where user_id=17) and is_jia=0) ids;

    -- SELECT GROUP_CONCAT(user_id) INTO finalVarEnd FROM @sql;
    
    -- SELECT COUNT(*) INTO total_num FROM @sql;

    SET @sql = concat('SELECT GROUP_CONCAT(user_id) INTO @finalVarEnd, COUNT(1) INTO @total_num FROM ',@sql);
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET finalVarEnd = @finalVarEnd;
    SET total_num = @total_num;
END IF;
END;
-- -------------------------------------------------------------

$$$ delimiter ;




delimiter $$$ 
-- CREATE FUNCTION "get_child_userfor" -------------------------
CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_child_userfor`(IN `pid` int,OUT `finalVarEnd` LONGTEXT,OUT `total_num` int)
BEGIN
# 功能：递归拿取传入的用户ID，无限下级ID。
# 修改人：Jessica
# 修改时间：2022-3-12
DECLARE finalVar LONGTEXT;
# 定义一个临时变量
DECLARE tempVar LONGTEXT;
DECLARE vcount INT;

# 设置默认值
SET finalVar=0;
SET vcount=0;
SET total_num=0;

# 转换入参类型
SET tempVar = CAST(pid AS CHAR);
# 循环体，如果当前的临时变量中没有值，为空的情况下跳出循环，也就是说没有子节点了
WHILE tempVar IS NOT NULL DO

# 将得到的子节点保存到变量中
IF tempVar!=pid THEN
    SET finalVar= CONCAT(finalVar,',',tempVar);
END IF;

SET total_num=vcount+total_num;
# 根据父Id查询所有的子节点
SELECT count(*) INTO vcount FROM xy_users t WHERE FIND_IN_SET(t.parent_id,tempVar)>0 and is_jia=0;
SELECT GROUP_CONCAT(t.id) INTO tempVar FROM xy_users t WHERE FIND_IN_SET(t.parent_id,tempVar)>0 and is_jia=0;

# 结束循环
END WHILE;

SELECT TRIM(LEADING '0,' FROM finalVar) INTO finalVarEnd;
END;
-- -------------------------------------------------------------

$$$ delimiter ;



delimiter $$$ 
-- CREATE FUNCTION "get_team_report" ---------------------------
CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_team_report`(
	IN `pid` INT,
	OUT `renshu` INT,
	OUT `charge` FLOAT,
	OUT `tixian` FLOAT,
	OUT `promos` FLOAT,
	OUT `ordermoney` FLOAT,
	OUT `yongjin` FLOAT,
	OUT `balance` FLOAT,
	OUT `prize` FLOAT,	
	OUT `rihuo` INT,
	OUT `depositnow` FLOAT,
	OUT `zongcunchu` FLOAT,
	OUT `youxiaoadd` INT
	)
BEGIN
# 功能：移动端调用的团队报表
# 修改人：Jessica
# 修改时间：2022-3-12
DECLARE v_table_column TEXT DEFAULT '(SELECT id from xy_users where id in (select id from xy_users where parent_id=@pid) and is_jia=0
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid) and is_jia=0
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid)) and is_jia=0
 union
 select id from xy_users where parent_id in (select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid))) and is_jia=0) b';
SET @sql = v_table_column;
SET @pid = pid;

#查询人数
-- select count(1) INTO renshu from (SELECT id from xy_users where id in (select id from xy_users where parent_id=pid) and is_jia=0
select count(1) INTO renshu from (select id from xy_users where parent_id=pid and is_jia=0
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id=pid  and is_jia=0) and is_jia=0
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=pid  and is_jia=0) and is_jia=0) and is_jia=0
 union
 select id from xy_users where parent_id in (select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=pid  and is_jia=0) and is_jia=0) and is_jia=0) and is_jia=0)a;

SET charge=0;
SET tixian=0;
SET promos=0;
SET ordermoney=0;
SET yongjin=0;
SET balance=0;
SET prize=0;
SET rihuo=0;
SET depositnow=0;
SET zongcunchu=0;
SET youxiaoadd=0;
IF renshu>0 THEN
#查询充值
SET @sql = concat('SELECT SUM(a.num) INTO @charge FROM xy_recharge a,', concat(@sql,' where a.uid=b.id and  a.status=2'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET charge = @charge;
		SET @sql = v_table_column;
#查询提现
SET @sql = concat('SELECT SUM(a.num) INTO @tixian FROM xy_deposit a,', concat(@sql,' where a.uid=b.id and  a.status=2'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET tixian = @tixian;
		SET @sql = v_table_column;
#查询提现中
SET @sql = concat('SELECT SUM(a.num) INTO @depositnow FROM xy_deposit a,', concat(@sql,' where a.uid=b.id and  a.status=1'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET depositnow = @depositnow;
		SET @sql = v_table_column;
#查询系统赠送
SET @sql = concat('SELECT SUM(a.num) INTO @promos FROM xy_balance_log a,', concat(@sql,' where a.uid=b.id and  a.type=0'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET promos = @promos;
		SET @sql = v_table_column;
#查询流水
SET @sql = concat('SELECT SUM(a.num) INTO @ordermoney FROM xy_convey a,', concat(@sql,' where a.uid=b.id and a.status=1'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET ordermoney = @ordermoney;
		SET yongjin = @yongjin;
		SET @sql = v_table_column;
#查询佣金
 set @sql = concat('select sum(a.commission) into @yongjin from xy_convey a,', concat(@sql,' where a.uid=b.id and a.status=1'));
     ## 预处理需要执行的动态sql，其中stmt是一个变量
     prepare stmt from @sql;  
     ## 执行sql语句
     execute stmt;  
     ## 释放掉预处理段
    deallocate prepare stmt;
     ## 赋值给定义的变量
     set yongjin = @yongjin;
 		set @sql = v_table_column;
#查询下级总余额
SET @sql = concat('SELECT SUM(a.balance) INTO @balance FROM xy_users a,', concat(@sql,' where a.id=b.id'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET balance = @balance;
		SET @sql = v_table_column;
#查询下级返佣
SELECT SUM(a.num) INTO prize FROM xy_reward_log a where a.sid=@pid and a.status=2 and a.type=2;
#查询下级活跃人数
SET @sql = concat('SELECT count(1) INTO @rihuo FROM (SELECT DISTINCT(c.uid) FROM xy_convey c  where c.status=1 union select DISTINCT(r.uid) from xy_recharge r where r.status=2 and r.uid not in(SELECT DISTINCT(x.uid) FROM xy_convey x where x.status=1)) a,', concat(@sql,' where a.uid=b.id'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET rihuo = @rihuo;
		SET @sql = v_table_column;

#查询提现中
SET @sql = concat('SELECT SUM(a.num) INTO @zongcunchu FROM xy_lixibao a,', concat(@sql,' where a.uid=b.id and  a.is_qu=0'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET zongcunchu = @zongcunchu;
		SET @sql = v_table_column;
#查询下级有效新增
select count(1) INTO youxiaoadd from (SELECT id from xy_users where id in (select id from xy_users where parent_id=pid) and is_jia=0 and isvalid=1
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id=pid) and is_jia=0 and isvalid=1
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=pid)) and is_jia=0 and isvalid=1
 union
 select id from xy_users where parent_id in (select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=pid))) and is_jia=0 and isvalid=1) a;
 END IF;
END;
-- -------------------------------------------------------------

$$$ delimiter ;



delimiter $$$ 
-- CREATE FUNCTION "get_team_report_center" --------------------
CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_team_report_center`(
	IN `pid` INT,
	IN `starttime` VARCHAR(25),
	IN `endtime` VARCHAR(25),
	OUT `TeamBalance` FLOAT,
	OUT `TeamFlow` FLOAT,
	OUT `TotalTeamRecharge` FLOAT,
	OUT `TotalTeamIncome` FLOAT,
	OUT `TotalTeamWithdrawal` FLOAT,
	OUT `TeamSize` INT,
	OUT `FirstlyRrecharge` FLOAT,
	OUT `DirectPromoters` INT,	
	OUT `ActivePeople` INT,
	OUT `NewlyIncreased` FLOAT
	)
BEGIN
# 功能：总后台团队总报表调用
# 修改人：Jessica
# 修改时间：2022-3-12
DECLARE v_table_column TEXT DEFAULT '(SELECT id from xy_users where id in (select id from xy_users where parent_id=@pid
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid) 
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid))
 union
 select id from xy_users where parent_id in (select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid)))) and is_jia=0 and addtime BETWEEN @starttime AND @endtime ) b';
DECLARE vcountOne INT;
DECLARE vcountTwo INT;
DECLARE vcountThree INT;
DECLARE vcountFour INT;
SET @sql = v_table_column;
SET @pid = pid;
SET @starttime = starttime;
SET @endtime = endtime;

#查询下级总余额
SET @sql = concat('SELECT SUM(a.balance) INTO @TeamBalance FROM xy_users a,', concat(@sql,' where a.id=b.id and a.addtime BETWEEN @starttime AND @endtime'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET TeamBalance = @TeamBalance;
		SET @sql = v_table_column;
#查询流水
SET @sql = concat('SELECT SUM(a.num) INTO @TeamFlow FROM xy_convey a,', concat(@sql,' where a.uid=b.id and a.status=1 and a.endtime BETWEEN @starttime AND @endtime'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET TeamFlow = @TeamFlow;
		SET @sql = v_table_column;
#查询充值
SET @sql = concat('SELECT SUM(a.num) INTO @TotalTeamRecharge FROM xy_recharge a,', concat(@sql,' where a.uid=b.id and  a.status=2 and a.endtime BETWEEN @starttime AND @endtime'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET TotalTeamRecharge = @TotalTeamRecharge;
		SET @sql = v_table_column;	
#查询下级返佣
SELECT SUM(a.num) INTO TotalTeamIncome FROM xy_reward_log a where a.sid=@pid and a.status=2 and a.type=2 and a.addtime BETWEEN @starttime AND @endtime;
#查询提现
SET @sql = concat('SELECT SUM(a.num) INTO @TotalTeamWithdrawal FROM xy_deposit a,', concat(@sql,' where a.uid=b.id and  a.status=2'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET TotalTeamWithdrawal = @TotalTeamWithdrawal;
		SET @sql = v_table_column;
#查询下级人数
select count(1) INTO vcountOne  from xy_users where parent_id=@pid and is_jia=0 and addtime BETWEEN starttime AND endtime;
select count(1) INTO vcountTwo from xy_users where parent_id in(select id from xy_users where parent_id=pid) and is_jia=0 and addtime BETWEEN starttime AND endtime;
select count(1) INTO vcountThree from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=pid)) and is_jia=0 and addtime BETWEEN starttime AND endtime;
select count(1) INTO vcountFour  from xy_users where parent_id in (select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=pid)))and is_jia=0 and addtime BETWEEN starttime AND endtime;
SET TeamSize=vcountOne+vcountTwo+vcountThree+vcountFour;
 
 
 
#查询首次充值
SET @sql = concat('SELECT count(DISTINCT(uid)) INTO @FirstlyRrecharge FROM xy_recharge a,', concat(@sql,' where a.uid=b.id and  a.status=2 and a.endtime BETWEEN @starttime AND @endtime'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET FirstlyRrecharge = @FirstlyRrecharge;
		SET @sql = v_table_column;	
#查询直推人数
select count(1) INTO DirectPromoters from xy_users where parent_id=pid and is_jia=0 and addtime BETWEEN starttime AND endtime;
#查询下级活跃人数
SET @sql = concat('SELECT count(1) INTO @ActivePeople FROM (SELECT DISTINCT(c.uid) FROM xy_convey c  where c.status=1 union select DISTINCT(r.uid) from xy_recharge r where r.status=2  and r.endtime BETWEEN @starttime AND @endtime and r.uid not in(SELECT DISTINCT(x.uid) FROM xy_convey x where x.status=1  and x.endtime BETWEEN @starttime AND @endtime)) a,', concat(@sql,' where a.uid=b.id'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET ActivePeople = @ActivePeople;
		SET @sql = v_table_column;
#查询下级有效新增
select count(1) INTO NewlyIncreased from (select id from xy_users where parent_id=@pid and is_jia=0 and isvalid=1 and addtime BETWEEN @starttime AND @endtime
 union
 select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid and is_jia=0 and addtime BETWEEN @starttime AND @endtime) and is_jia=0 and isvalid=1 and addtime BETWEEN @starttime AND @endtime
 union
select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid and is_jia=0 and isvalid=1 and addtime BETWEEN @starttime AND @endtime)) and is_jia=0 and isvalid=1 and addtime BETWEEN @starttime AND @endtime
 union
select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id in(select id from xy_users where parent_id=@pid and is_jia=0 and isvalid=1 and addtime BETWEEN @starttime AND @endtime))) and is_jia=0 and isvalid=1 and addtime BETWEEN @starttime AND @endtime ) a;
END;
-- -------------------------------------------------------------

$$$ delimiter ;



delimiter $$$ 
CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_team_report_test`(
    IN `pid` INT,
    OUT `renshu` INT,
    OUT `charge` FLOAT,
    OUT `tixian` FLOAT,
    OUT `promos` FLOAT,
    OUT `ordermoney` FLOAT,
    OUT `yongjin` FLOAT,
    OUT `balance` FLOAT,
    OUT `prize` FLOAT,  
    OUT `rihuo` INT,
    OUT `depositnow` FLOAT,
    OUT `zongcunchu` FLOAT,
    OUT `youxiaoadd` INT
    )
BEGIN

DECLARE v_table_column LONGTEXT;
DECLARE finalVarEnd LONGTEXT;
DECLARE totalnum INT;


-- 从上一个无限查下级的方法中查下级
CALL get_child_userfor(pid,finalVarEnd,totalnum);
SET @allsonids=finalVarEnd;
SET @renshu=totalnum;

set @v_table_column = "(SELECT substring_index(substring_index(@allsonids,',', h.help_topic_id + 1), ',', -1) id FROM mysql.help_topic h where
 h.help_topic_id <  (LENGTH(@allsonids) - LENGTH(REPLACE(@allsonids, ',', '')) + 1)) b";

SET @pid=pid;
set @sql=@v_table_column;


SET charge=0;
SET tixian=0;
SET promos=0;
SET ordermoney=0;
SET yongjin=0;
SET balance=0;
SET prize=0;
SET rihuo=0;
SET depositnow=0;
SET zongcunchu=0;
SET youxiaoadd=0;


IF totalnum > 0 THEN
#查询充值
SET @sql = concat('SELECT SUM(a.num) INTO @charge FROM xy_recharge a,', concat(@sql,' where a.uid=b.id and  a.status=2'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET charge = @charge;
        SET @sql = v_table_column;
#查询提现
SET @sql = concat('SELECT SUM(a.num) INTO @tixian FROM xy_deposit a,', concat(@sql,' where a.uid=b.id and  a.status=2'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET tixian = @tixian;
        SET @sql = v_table_column;
#查询提现中
SET @sql = concat('SELECT SUM(a.num) INTO @depositnow FROM xy_deposit a,', concat(@sql,' where a.uid=b.id and  a.status=1'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET depositnow = @depositnow;
        SET @sql = v_table_column;
#查询系统赠送
SET @sql = concat('SELECT SUM(a.num) INTO @promos FROM xy_balance_log a,', concat(@sql,' where a.uid=b.id and  a.type=0'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET promos = @promos;
        SET @sql = v_table_column;
#查询流水
SET @sql = concat('SELECT SUM(a.num) INTO @ordermoney FROM xy_convey a,', concat(@sql,' where a.uid=b.id and a.status=1'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET ordermoney = @ordermoney;
        SET yongjin = @yongjin;
        SET @sql = v_table_column;
#查询佣金
 set @sql = concat('select sum(a.commission) into @yongjin from xy_convey a,', concat(@sql,' where a.uid=b.id and a.status=1'));
     ## 预处理需要执行的动态sql，其中stmt是一个变量
     prepare stmt from @sql;  
     ## 执行sql语句
     execute stmt;  
     ## 释放掉预处理段
    deallocate prepare stmt;
     ## 赋值给定义的变量
     set yongjin = @yongjin;
        set @sql = v_table_column;
#查询下级总余额
SET @sql = concat('SELECT SUM(a.balance) INTO @balance FROM xy_users a,', concat(@sql,' where a.id=b.id'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET balance = @balance;
        SET @sql = v_table_column;
#查询下级返佣
SELECT SUM(a.num) INTO prize FROM xy_reward_log a where a.sid=@pid and a.status=2 and a.type=2;
#查询下级活跃人数
SET @sql = concat('SELECT count(1) INTO @rihuo FROM (SELECT DISTINCT(c.uid) FROM xy_convey c  where c.status=1 union select DISTINCT(r.uid) from xy_recharge r where r.status=2 and r.uid not in(SELECT DISTINCT(x.uid) FROM xy_convey x where x.status=1)) a,', concat(@sql,' where a.uid=b.id'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET rihuo = @rihuo;
        SET @sql = v_table_column;

#查询提现中
SET @sql = concat('SELECT SUM(a.num) INTO @zongcunchu FROM xy_lixibao a,', concat(@sql,' where a.uid=b.id and  a.is_qu=0'));
    ## 预处理需要执行的动态SQL，其中stmt是一个变量
    PREPARE stmt FROM @sql;  
    ## 执行SQL语句
    EXECUTE stmt;  
    ## 释放掉预处理段
    deallocate prepare stmt;
    ## 赋值给定义的变量
    SET zongcunchu = @zongcunchu;
        SET @sql = v_table_column;

#查询下级有效新增
SET @sql = concat('SELECT COUNT(1) INTO @youxiaoadd FROM xy_users a,', concat(@sql,' where a.id=b.id and  a.isvalid=1'));
END IF;
END;
-- -------------------------------------------------------------

$$$ delimiter ;


delimiter $$$ 
-- -------------------------------------------------------------

CREATE DEFINER=`sd_testfbd_com`@`%` PROCEDURE `get_report_Infinite_level`(IN `pid` INT,
    OUT `renshu` INT,
    OUT `charge` FLOAT,
    OUT `tixian` FLOAT,
    OUT `promos` FLOAT,
    OUT `ordermoney` FLOAT,
    OUT `yongjin` FLOAT,
    OUT `balance` FLOAT,
    OUT `prize` FLOAT,  
    OUT `rihuo` INT,
    OUT `depositnow` FLOAT,
    OUT `zongcunchu` FLOAT,
    OUT `youxiaoadd` INT)
BEGIN
# 功能：后台调用的团队报表（不限下级）
# 修改人：Jessica
# 修改时间：2022-3-28
DECLARE v_table_column LONGTEXT;
DECLARE allsonids LONGTEXT;
CALL get_childs_by_user_tree(pid,@finalVarEnd,@totalnum);
#查询人数
SET renshu=@totalnum;
#获取所有子级人数
SELECT @finalVarEnd INTO @newData;
SET allsonids=@newData;
#获取相关汇总数据
SET charge=0;
SET tixian=0;
SET promos=0;
SET ordermoney=0;
SET yongjin=0;
SET balance=0;
SET prize=0;
SET rihuo=0;
SET depositnow=0;
SET zongcunchu=0;
SET youxiaoadd=0;
IF renshu>0 THEN
#查询充值
SELECT SUM(r.num) INTO charge FROM xy_recharge r  where r.status=2 and FIND_IN_SET(r.uid,allsonids);
#查询提现       
SELECT SUM(d.num) INTO tixian FROM xy_deposit d  where d.status=2 and FIND_IN_SET(d.uid,allsonids);
#查询提现中
SELECT SUM(d.num) INTO depositnow FROM xy_deposit d  where d.status=1 and FIND_IN_SET(d.uid,allsonids);
#查询系统赠送
SELECT SUM(b.num) INTO promos FROM xy_balance_log b  where b.type=0 and FIND_IN_SET(b.uid,allsonids);
#查询流水
SELECT SUM(c.num) INTO ordermoney FROM xy_convey c  where c.status=1 and FIND_IN_SET(c.uid,allsonids);
#查询佣金
SELECT SUM(o.commission) INTO yongjin FROM xy_convey o  where o.status=1 and FIND_IN_SET(o.uid,allsonids);
#查询下级总余额
SELECT SUM(u.balance) INTO balance FROM xy_users u  where u.status=1 and FIND_IN_SET(u.id,allsonids);
#查询下级返佣
SELECT SUM(r.num) INTO prize FROM xy_reward_log r where r.sid=pid and r.status=2 and r.type=2;
#查询下级活跃人数
SELECT count(1) INTO rihuo FROM (SELECT uid from (SELECT DISTINCT(c.uid) FROM xy_convey c  where c.status=1 union select DISTINCT(r.uid) from xy_recharge r where r.status=2 and r.uid not in(SELECT DISTINCT(x.uid) FROM xy_convey x where x.status=1)) a where FIND_IN_SET(a.uid,allsonids)) b;
#查询余额宝总存储
SELECT SUM(a.num) INTO zongcunchu FROM xy_lixibao a  where a.is_qu=0 and FIND_IN_SET(a.uid,allsonids);
#查询下级有效新增
select count(1) INTO youxiaoadd from (SELECT id from xy_users where isvalid=1 and FIND_IN_SET(id,allsonids)) a;
 END IF;
END
-- -------------------------------------------------------------

$$$ delimiter ;
