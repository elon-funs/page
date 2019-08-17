-- Valentina Studio --
-- MySQL dump --
-- ---------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- ---------------------------------------------------------


-- DROP DATABASE "datamoney" -------------------------------
DROP DATABASE IF EXISTS `datamoney`;
-- ---------------------------------------------------------


-- CREATE DATABASE "datamoney" -----------------------------
CREATE DATABASE `datamoney` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `datamoney`;
-- ---------------------------------------------------------


-- CREATE TABLE "article" --------------------------------------
CREATE TABLE `article` ( 
	`id` Int( 10 ) UNSIGNED AUTO_INCREMENT NOT NULL,
	`title` VarChar( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`author` VarChar( 6 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'andy',
	`read` Int( 11 ) NOT NULL DEFAULT 0,
	`reply` Smallint( 6 ) NOT NULL DEFAULT 0,
	`like` Smallint( 6 ) NOT NULL DEFAULT 0,
	`pick` Smallint( 6 ) NOT NULL DEFAULT 0,
	`share` TinyInt( 4 ) NOT NULL DEFAULT 0 COMMENT 'user-s share',
	`income` TinyInt( 4 ) NOT NULL DEFAULT 0 COMMENT 'income total',
	`income_total` Smallint( 6 ) NOT NULL DEFAULT 0,
	`type` TinyInt( 4 ) NOT NULL DEFAULT 1 COMMENT '1data,2finance,3share',
	`created_at` Timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` Timestamp NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8
COLLATE = utf8_general_ci
ENGINE = InnoDB
AUTO_INCREMENT = 34;
-- -------------------------------------------------------------


-- CREATE TABLE "migrations" -----------------------------------
CREATE TABLE `migrations` ( 
	`id` Int( 10 ) UNSIGNED AUTO_INCREMENT NOT NULL,
	`migration` VarChar( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`batch` Int( 11 ) NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8
COLLATE = utf8_general_ci
ENGINE = InnoDB
AUTO_INCREMENT = 7;
-- -------------------------------------------------------------


-- CREATE TABLE "password_resets" ------------------------------
CREATE TABLE `password_resets` ( 
	`email` VarChar( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`token` VarChar( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`created_at` Timestamp NULL )
CHARACTER SET = utf8
COLLATE = utf8_general_ci
ENGINE = InnoDB;
-- -------------------------------------------------------------


-- CREATE TABLE "tag" ------------------------------------------
CREATE TABLE `tag` ( 
	`id` Int( 10 ) UNSIGNED AUTO_INCREMENT NOT NULL,
	`tag` VarChar( 30 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'tag name',
	`explain` VarChar( 60 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'explain for tag',
	`type` TinyInt( 4 ) NOT NULL DEFAULT 1 COMMENT '1data,2finance,3share',
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8
COLLATE = utf8_general_ci
ENGINE = InnoDB
AUTO_INCREMENT = 1;
-- -------------------------------------------------------------


-- CREATE TABLE "users" ----------------------------------------
CREATE TABLE `users` ( 
	`id` Int( 10 ) UNSIGNED AUTO_INCREMENT NOT NULL,
	`name` VarChar( 18 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`accout_type` TinyInt( 4 ) NOT NULL,
	`email` VarChar( 25 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`wechat` VarChar( 18 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`qq` BigInt( 20 ) NULL,
	`facebook` VarChar( 20 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`linkedin` VarChar( 20 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`github` VarChar( 20 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`phone` BigInt( 20 ) NULL,
	`alipay` VarChar( 20 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`weibo` VarChar( 20 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`password` VarChar( 18 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`remember_token` VarChar( 100 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
	`created_at` Timestamp NULL,
	`updated_at` Timestamp NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8
COLLATE = utf8_general_ci
ENGINE = InnoDB
AUTO_INCREMENT = 1;
-- -------------------------------------------------------------


-- CREATE TABLE "words" ----------------------------------------
CREATE TABLE `words` ( 
	`id` Int( 10 ) UNSIGNED AUTO_INCREMENT NOT NULL,
	`aid` Int( 10 ) NOT NULL DEFAULT 0 COMMENT 'article id',
	`word` LongText CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8
COLLATE = utf8_general_ci
ENGINE = InnoDB
AUTO_INCREMENT = 34;
-- -------------------------------------------------------------


-- Dump data of "article" ----------------------------------
LOCK TABLES `article` WRITE;

/*!40000 ALTER TABLE `article` DISABLE KEYS */

BEGIN;

REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '1', 'Ubuntu-apt-package-预装软件御载与彻底删除与完全清除', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '2', 'Ubuntu-deb-包deb软件安装', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '3', 'Ubuntu-system-系统设置打不开', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '4', 'Ubuntu-apt-deb-package-安装过的软件包管理', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '5', 'Linux-Ubuntu-Centos-设置命令行补全不区分大小写', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '6', 'Linux-Ubuntu-Centos-git-github-下查找大于50M的文件', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '7', 'Linux-Ubuntu-Centos-Mac-查看服务器ip', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '8', 'Linux-Ubuntu-Centos-docker-中缺少没有ifconfig,netstat,等相关库时请自行安装', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '9', 'Linux-Apache-VHOSTS-多域名多端口网站虚拟主机配置', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '10', 'Linux-Apache-URL-Rewite-访问路径重定向只有首页能访问,其他页面访问不了', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '11', 'Docker-Docker-compose-系统中没有linux导致相关命令或类库功能,会导致程序无法在容器当中执行', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '12', 'Docker-compose-docker-增加固定IP增加域名映射docker_compose配置', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '13', 'Linux-Mysql-远程访问配置', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '14', 'Linux-Mysql-数据库主从配置的关键说明', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '15', 'Linux-Redis-PHP-在php程序中实现redis实现批量操作多个值的修改增加', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '16', 'Linux-Redis-在Redis设置一个空间即目录或直接独立库内专用于键空通知事件', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '17', 'Linux-Redis-Mysql-间数据互换,以实现站数据先在redis内存,记录并响应,然后在mysql操作持久化,从而解决数据库瓶颈和数据库的一致性问题', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '18', 'Linux-Reids-Mysql-redis<=>Mysql数据转移在命令行中进行比程序中效率高几十倍', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '19', 'PHP-学习感悟', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '20', 'Linux-ubuntu-php-memcached-安装服务及扩展库', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '21', 'Linux-Ubuntu-PHP-Redis安装服务及扩展', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '22', 'git-github-记住密码提交更新代码', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '23', 'git-github-搭建自己的代码管理服务器', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '24', 'git-gitignore-修改忽略文件', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '25', 'Ubuntu-snap-apt-package-安装nextcloud一分钟搭建自己私有云', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '26', 'Linux-Ubuntu-Mac-Android-Iphone-手机投屏到电脑上最简单的方法', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '27', 'Mysql-Binlog-开启后数据库无法启动bin_log_basename没有这个变量', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '28', 'Mysql-Sql-常用操作', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '29', 'Mysql-Sql-程序员必知的DBA必须掌握的基本知识', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '30', 'Mysql-Sql-Shell-数据库自动备份脚本', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '31', 'Nginx-Server-网站虚拟主机配置端口还目录转发', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '32', 'Gold-Invest-2019年8月第一周黄金交易回顾和总结', 'andy', '0', '0', '0', '0', '0', '0', '0', '3', '2019-08-10 22:06:23', '2019-08-10 22:06:23' );
REPLACE INTO `article`(`id`,`title`,`author`,`read`,`reply`,`like`,`pick`,`share`,`income`,`income_total`,`type`,`created_at`,`updated_at`) VALUES ( '33', 'Code-App-Pass,Sass分享几个极少代码甚至不写代码就能免费上线自己的APP', 'andy', '0', '0', '0', '0', '0', '0', '0', '1', NULL, '2019-08-13 11:57:47' );
COMMIT;
/*!40000 ALTER TABLE `article` ENABLE KEYS */

UNLOCK TABLES;

-- ---------------------------------------------------------


-- Dump data of "migrations" -------------------------------
LOCK TABLES `migrations` WRITE;

/*!40000 ALTER TABLE `migrations` DISABLE KEYS */

BEGIN;

REPLACE INTO `migrations`(`id`,`migration`,`batch`) VALUES ( '1', '2014_10_12_000000_create_users_table', '1' );
REPLACE INTO `migrations`(`id`,`migration`,`batch`) VALUES ( '2', '2014_10_12_100000_create_password_resets_table', '1' );
REPLACE INTO `migrations`(`id`,`migration`,`batch`) VALUES ( '3', '2017_08_06_120323_create_article_table', '1' );
REPLACE INTO `migrations`(`id`,`migration`,`batch`) VALUES ( '4', '2017_08_11_061115_add_pick_to_article_table', '1' );
REPLACE INTO `migrations`(`id`,`migration`,`batch`) VALUES ( '5', '2017_08_26_072730_create_partword_table', '1' );
REPLACE INTO `migrations`(`id`,`migration`,`batch`) VALUES ( '6', '2018_04_11_000125_create_tag_table', '1' );
COMMIT;
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */

UNLOCK TABLES;

-- ---------------------------------------------------------


-- Dump data of "password_resets" --------------------------
-- ---------------------------------------------------------


-- Dump data of "tag" --------------------------------------
-- ---------------------------------------------------------


-- Dump data of "users" ------------------------------------
-- ---------------------------------------------------------


-- Dump data of "words" ------------------------------------
LOCK TABLES `words` WRITE;

/*!40000 ALTER TABLE `words` DISABLE KEYS */

BEGIN;

REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '1', '1', '<span class="coderead">sudo apt-get remove packagename --purge && apt-get autoremove --purge && apt-get clean</span> ' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '2', '2', 'ubuntu下面可以直接安装,<div class="coderead">sudo dkpg -i filename.deb</div>如果不支持则需安装 i386 的对应对功能包即可' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '3', '3', '#>0思路
如果你曾删除过配置文件,尤其是输入法.则往下阅读,否则无用.
是由于卸载ibus导致的,unity-control-center依赖ibus,卸载ibus unity-control-center也会被卸载所以 不能乱动。
#>1重新安装gnome-control-center
<div class="coderead">sudo apt-get install gnome-control-center</div>
#2.重新安装unity-control-center 
<span class="coderead">sudo apt-get install unity-control-center </span>//如果设置里只有很少的几个图标请重新安装unity-control-center
#3.重新安装gnome
<span  class="coderead">sudo apt-get install ubuntu-desktop</span>//这个会把Ubuntu预装的软件,装完自己再慢慢卸载吧或者他也提供了一次性的安装办法' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '4', '4', '#>1apt
	<span class="coderead">sudo apt list --installed</span> 
#>2dpkg&deb
	<span class="coderead">sudo dpkg-query -l</span> ' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '5', '5', '#>0思路
	系统自带这个功能打开配置即可:
#>1
	<div class="coderead">nano ~/.inputrc,如果没这个文件就新建一个</div>
#2粘贴上以下语句:
	<div class="coderead">set completion-ignore-case on
set show-all-if-ambiguous on
TAB: menu-complete</div>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '6', '6', '#>0思路
	因为github不接受大于100m的单个文件,你提交,push,等2小时后,以为是传完了, 但结果提示你失败.
	尊贵的vip不在此列. 
		
#>1
	<div class="coderead">find ./data -type f -size +50000 </div>//查找到它
#>2
	<div class="coderead">find ./data -type f -size +50000 >> .gitignore</div>//忽略他' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '7', '7', '#>0思路
	命令行查网卡信息.还有你都有公网了,找第三方的api查.建议做成自定义命令方便使用.	#>1系统自带的命令行
	<div class="coderead">ip addr|grep inet|grep global</div>
#>2linux-全部可用
	<div class="coderead">ifconfig</div>	
#>3第三方api
	<span class="coderead">curl ifconfig.me</span>//提供服务的这类服务的比较多, 把上面的url换成, tool.lu/ip, https://www.ip.cn等等.如果你有给我分享哈~
#>4mac osx本机专用的.
	<span class="coderead">brew install archey</span>这个在mac本机使用相当舒服务	
#5最好是加个自定义命令,下回能用是吧.
	<div class="coderead">echo  alias myip="curl http://www.ifconfig.me" >> ~/.bashrc && source ~/.bashrc</div>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '8', '8', '#>0思路
	docker容器内是有apk(alpine),apt,yum 这种安装方式的, 当然看你的容器系统而不同,莫荒.
#>1
	直接使用<span class="coderead">yum(apt) -y install net-tools</span> 即可' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '9', '9', '#>0思路
	这个也算是web开发的基本功了,详细写一下.一般情况都写思路和要点.	
#>1配置文件内容-案例1
<div class="coderead">
&#60;VirtualHost *:80&#62;
	ServerName datamoney.net 
	ServerAlias www.datamoney.net

	DocumentRoot /code/datamoney/
	Options Indexes FollowSymLinks

	&#60;Directory "/code/datamoney/public"&#62;
		AllowOverride All
		&#60;IfVersion < 2.4&#62;
			Allow from all
		&#60;/IfVersion&#62;
		&#60;IfVersion >= 2.4&#62;
			Require all granted
		&#60;/IfVersion&#62;
	&#60;/Directory&#62;
&#60;/VirtualHost&#62;
</div>
#>2配置项目说明	
	#>2>1端口配置
<div class="coderead">
	上文:&#60;VirtualHost *:80&#62;
	改为:&#60;VirtualHost *:8001&#62;,
		&#60;VirtualHost *:8002&#62;,
		&#60;VirtualHost *:8003&#62;
</div>
	对应你在浏览器访问网站,
	datamoney.net:80,
	datamoney.net:8001,
	datamoney.net:8002,
	datamoney.net:8003,
	就是3个网站.
	聪明的你发现了吧, 后缀即端口不同.

	#>2>2域名配置
<div class="coderead">
	ServerName 	datamoney.net 改为 
	ServerName  8001.datamoney.net
	ServerName  8002.datamoney.net
	ServerName  8003.datamoney.net
</div>
	对应你在浏览器
	datamoney.net,
	8001.datamoney.net,
	8002.datamoney.net,
	8003.datamoney.net,
	又是3个网站
	//前面不同,即域名不同.

	#>2>3字段解释
	<span class="coderead">&#60;VirtualHost *:&#62;</span>"*:80"-*表示啥字母数字都行,":80"默认是80,我们没写就默认80了.  
	<span class="coderead">ServerAlias www.datamoney.net</span>//这行是别名. 多个域名的指向一个网站.
	<span class="coderead">DocumentRoot /code/datamoney/</span>//配置的网站根目录,无论是否虚拟主机
	<span class="coderead">Options Indexes FollowSymLinks</span>//这个是可以入口文件类型.如index.html,index.php,index.htm

#>3禁止访问
	可以加当然可以减,能开启也可以禁止嘛.
	一般是不想让人你直接用IP来访问.
	当然除了禁止.还用别的办法对吧.如转给百度,自行发挥,按需使用.
<div class="coderead">
	&#60;VirtualHost *:80&#62;
		ServerName 127.0.0.1
		ServerAlias *
		&#60;Location /&#62;
		Order Allow,Deny
		Deny from all
		&#60;/Location&#62;
	&#60;/VirtualHost&#62;
</div>
#>4启用/禁用某个配置文件
	<span class="coderead">a2dissite onevhost.conf </span>//禁用此虚拟配置文件
	<span class="coderead">a2ensite onevhost.conf </span>//启用某虚拟配置文件
		
#>5重启-是计算机世界的良药
	重启的是服务!!!systemctl 或者 service都有服务管理功能,但具体不同另开篇细讲,apache在你的机器里叫什么名字,得自己看,httpd/apache2比较常见.
	<span class="coderead">service apache2 restart.//service httpd restart</span>
	或者
	<span class="coderead">systemctl apache2 restart.//systemctl httpd restart</span>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '10', '10', '#>1现象
	如果只有index.php可以访问/index.php同级文件也能访问,其他页面apache提示404.
#>2
	如果你的index.php目录下没有.htaccess这个文件请拿去摆好再重启.
<div class="coderead">
&#60;IfModule mod_rewrite.c&#62;
	Options +FollowSymlinks -Multiviews
	RewriteEngine On
	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]
&#60;/IfModule&#62;
</div>
#>3先开启解决问题
	<span class="coderead">sudo a2enmod rewrite</span>//重启apache
	<span class="coderead">service apache2 restart</span>//service httpd restart
	或者
	<span class="coderead">systemctl apache2 restart</span>//systemctl httpd restart
#4原因分析
	现代框架基本上都会重写url.就是访问 http://localhost/user/login.php,这个文件不一定在根目录/user/下, 当然login.php文件里要引用的js/css/html路径也未必一是真的.
#>5为什么
	为了安全,不能让人一眼看到我的网站根目录及各级目录.如果敌人了解你,就能更有效的进攻你.所以你得隐藏得改写.重新弄一套url和文件的对应关系.一个网站80万url怎么管.你别担心.框架就是改好了,你得再看看所用框架路由规则/静态规则就明白了.
#>6题外话
	有人会觉得我太笼统或不细致,因为快速理解和解决问题是我的出发点.
	我想能发现这些问题的人,一不需要读.二你应该能正确理解的我用意.
	设身处地,如你有更好的方式,让不懂的人快速明白和处理问题,请告知我
' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '11', '11', '#>0思路
	dockerk 中没有完整的Linux命令,如果代码程序在docker中运行, 程序在执行ps判断进程时可能出错, 解决方案, busybox 一篮子命令,或者一一安装 , crontab , procps(ps).
	apk,apt ,yum 等看你的容器而定' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '12', '12', '#>1先来一份配置文件
<div class="coderead">
networks:
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/24
  backend:
    driver: bridge
    ipam:
      config:
         - subnet: 172.19.0.0/24
services:
    code:
      image: mysql:last
      volumes:
        - /var/code:/var/code:cached
      extra_hosts:
        - "s.com:172.19.0.1"
      ports:
        - "2222:22"
        - "6379:6379"
        - "80:80"
      hostname:
        myname 
      tty: true
      environment:
        - MYSQL_DATABASE=${MYSQL_DATABASE}
        - MYSQL_USER=${MYSQL_USER}
        - TZ=${TIMEZONE}
      networks:
        frontend:
          ipv4_address: 172.18.0.1
        backend:
          ipv4_address: 172.19.0.1
</div>
#>2上述配置详细说明--建议看看官方手册
<span class="coderead">networks:</span>docker的网络配置
  <span class="coderead">frontend:</span>建个组,给组起个名字,一组管理很多个,方便嘛.
    <span class="coderead">driver: bridge</span>这个组的类型-当前是桥接
    <span class="coderead">ipam:</span>网卡/网关配置
      <span class="coderead">config:</span>
        <span class="coderead">- subnet: 172.18.0.0/24</span>网关和网段.
        backend 同理略.
<span class="coderead">services:</span>容器服务配置
  <span class="coderead">code:</span>容器名code.起名叫code在容器间通信时名字是有唯一值作用的
    <span class="coderead">extra_hosts:</span>//
      在这里加的域名,相当于容器内/etc/hosts.增加localhost域名。兩者不同在于重启后依然生效.!!!特別是你访问a域名,ad在程序内运行时访问B网站.此时同端口同地址同网站已发生资源抢夺,整个程序死掉.
      有人说:我在访问一个页面,程序也是同时调用nginx,php.mysql,redis为啥没事.为啥?!
      勉强回答,不同的服务和端口,相互不抢占彼此通道.
      <span class="coderead">- "s.com:172.19.0.1"</span>//举例1,前面是域名,你还是要在本地宿主机解析localhost的.Ip是你的容器网关ip,
    <span class="coderead">hostname:</span>//有了他,你主机名不再是串字符乱码而是名字了,方便命令行无他.
      <span class="coderead">myname </span>
    <span class="coderead">tty: true</span>//想进容器的命令行就得
    <span class="coderead">environment:</span>//这个也很有用, 比如要输入的账户密码,时区语言等. 
      <span class="coderead">- MYSQL_DATABASE=${MYSQL_DATABASE}</span>
      <span class="coderead">- MYSQL_USER=${MYSQL_USER}</span>
      <span class="coderead">- TZ=${TIMEZONE}</span>
    <span class="coderead">networks:</span>//这里我们给当前容器分配一个固定Ip,重启后也不会变.数据库连接超有用.
      <span class="coderead">frontend:</span>
        <span class="coderead">ipv4_address: 172.18.0.1</span>
      <span class="coderead">backend:</span>
        <span class="coderead">ipv4_address: 172.19.0.1</span>
' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '13', '13', '#>1.得先有用户名和密码吧, 没有就创建如:用户名是 remote ,密码是123456
#>2.可忽略,查看当前用户状态
<span class="coderead">select host,user,password from user where user = "remote";</span>
#>3.让 remote 能从你所在的IP登陆,%表示哪个ip都能登陆
<span class="coderead">update user set host = "%" where user = "remote"</span>
#>4.让 remote 对数据库有操作权限,不然登陆什么也干不了
<span class="coderead">grant all privileges on *.* to remote@"%" identified by "123456";</span>
#>5.更新相当于刷新保存你的设置
<span class="coderead">flush privileges;</span>
#>6.可选,上面没升效,那就重启mysql: 
<span class="coderead">sudo service mysql restart</span>
#>7.如果不行,再从1到6检查对不对。先检查一次,还不行？

#>8最终级处理,直接去修改mysql配置文件,让他可以远程登陆:
#>8>1
参考路径: /etc/mysql/mysql.conf.d/mysqld.cnf 
就是这行:<span class="coderead"> bind-address            = 127.0.0.1</span>
修改成: <span class="coderead"> bind-address            = 0.0.0.0</span>
#>8>2再来更新
<span class="coderead"> flush privileges</span> 
#>8>3重启mysql
<span class="coderead">sudo service mysql restart</span>
就可以用你现在的账户密码去登陆了。   ' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '14', '14', '#>0思路
    比如:你从a数据库导出a.sql，在b机导入a.sql，你说a和ｂ这段数据是不是完全一样的？？一样吧？！好，那a和b约定好，只要a一动，就如上述传一次数据，你说ab是否就同步了呢？当然啦！那这个工作能不能自动化，而且更延时最小几乎是实时的，要高效还要稳定可靠？
    能！都能！！--- 前辈都想到了，程序也写好了，这就是同步技术。而且前辈人想到的更多更全更远，看官请听。
    
    #>0>1. mysql 有bin-log(二进制日志)这个功能。二进制=可移植可执行[就是哪台机拿到都能直接运行]，日志=实时记录，有了它，人工从a库导出a.sql，这一步有了自动化级的实现方式。
    #>0>2.让a,b机器建立关联，tcp/Ip保连接，哪台生成日志并发出，哪N台接收并执行。
    #>0>3.其他配置项，传输的频次，能不能只传其中一个库等等 甚至二进制程序如何生成,怎么运行,怎么传输等等不属于配置问题了, mysql已实现。不用操心,想研究个具体实现的请进入另一个主题

#>1. 第一台机器叫主服,让他来生成日志并发出。给这台mysql起个名字server-id = 1 开启二进制日志,给日志起个文件名,存放路径也可以自己定,不写就默认
    <div class="coderead">
    echo "server-id=1
    log_bin=mysql-bin
    log_error=mysql-bin.err
    lower_case_table_names=1"
    >> /etc/mysql/conf.d/my.cnf
    </div>
    // 不需要同步哪些-就设置不产生日志,另一台就自然没了来源。
    <div class="coderead">
    binlog-ignore-db = mysql  
    binlog-ignore-db = test
    </div>  
    // 只同步指定数据库,除此之外,其他不同步  
    <div class="coderead">
    binlog-do-db = game
    binlog-ignore-db = information_schema  
    </div>
#>2.在主服务器创建一个专门的同步用户,一般都是只读嘛
    <span class="coderead">GRANT REPLICATION SLAVE ON *.* TO "slave"@"%" IDENTIFIED BY "123456";</span>
#>3.
    ！！建好后千万别乱动！！,一动就有日志了呀，是不是这个道理？走,搞另一台服务器叫从服吧。
    
#>4.在从服务器上加入对应的主服务器配置信息。
    上文有提到要分配 server-id,别忘记了,
    master就是主机嘛， master的ip/数据库端口/同步用的账户/密码/日志文件名/位置。
    下面不能全复制！！后两项会一直变，第5告诉你怎么查。
    <div class="coderead">
    CHANGE MASTER TO 
    MASTER_HOST="172.19.6.2",
    MASTER_PORT=3306,
    MASTER_USER = "slave",
    MASTER_PASSWORD = "123456",
    MASTER_LOG_FILE = "slave-mysql-bin.000001",
    MASTER_LOG_POS = 430;
    </div>
#>5其他用到的命令
    mysql文件配置文件地址 /etc/mysql/conf.d/my.cnf                  
    <span class="coderead">start slave</span>//开始同步。
    <span class="coderead">stop slave</span>;//修改配置信息时, 需要先停止同步服务。
    <span class="coderead">show slave status</span> //看你配置成功没
    <span class="coderead">show master status</span>//第4项用得上 
    <span class="coderead">show grants for "slave"@"%"</span> //看你要复制的库有没有权限。

#>6特别提示
    流程确保没问题，但同步配置失败3-5次是正常的。
    两台数据库同时配置完成,再操作建库建表等数据操作.关键问题:就是不要在没同步前产生日志.
    配置成功后建议，要多试几次，测试几个功能点。如果配置失败，你就更要多再多试几次。

' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '15', '15', '#>0思路
	背景redis原生支持批量操作[除特别旧的版本],一条命令加多个值到set/list的,但php-redis 扩展或框架是循环单条实现的批量操作。
	$redis->lPush($key, string $v1,string $v2,string $v3);redis本身实现批量但是对于参数格式为 
	$redis->lPush($key, ...$r);那结合php7的可变参数即可实现,[最终生成的redis操作命令未进行核实]' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '16', '16', '#>0思路
	redis键空事件是延迟执行和定时任务不二的选择,只是redis的可靠性-[高可用redis],值得进一步研究,也由此可推理出,redis做定时,做延迟,做时间序列等时间任务。
	redis 可以通过 hset user:name elon , user目录下的 key(name)=> value(elon);这样管理键值过期事件,更清晰些' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '17', '17', '#>0思路
将 mysql.user 表存入 redis中 set key(user) value({
  "field":["id","username","pwd","status"],
   "row-id":{1:"1,andy,password,1",2:"2,elon,elonpass,1"}
})
数据类型结构等看需求变更。或如:
<div class="coderead">
{
  "field":["id","username","pwd","status","table2中字段bb"],
   "row-id":["1,andy,password,1,bb1","2,elon,elonpass,1,bb2"]
}
</div>
解决用户写入,和热数据取出的问题即可,数据不必全吃内存' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '18', '18', '#>0思路
  redis格式例如: hset key value [expired] [ect]
  在mysql中创建视图表,设置 hset,key,value,[expired],[ect] select contact(hset,"空格",key,"空格",value,"空格"[expired],"空格"[ect]) 以生成 redis 原生命令格式,把这段mysql操作,写成 sql脚本,在命令行直接执行即可.
  <span class="coderead">mysql stats_db --skip-column-names --raw < mysql_to_red is.sql | redis-cli --pipe</span>
  参考:https://www.oschina.net/translate/mysql-to-redis-in-one-step' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '19', '19', '#>1
	php 是C语言写的软件或程序就像你电脑上装qq/微信来聊天,安浏览器看网站一样。你想让电脑做某件事情时,就可以需要一个相关的工具。php没有区别,你想让Php来做你想做的事情（搞个网站嘛）。
#>2
	你装好了微信,想玩小游戏,装好浏览器像看电影,你就找你想看的片名或游戏,再看他玩他。php装好了你也也找些相关资源（等同电影）,别人写好的本子拍好的片子,你用他做你想做的' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '20', '20', '#>1
	<div class="coderead">sudo apt-get install memcached php-memcached</div>
#>2
	<span class="coderead">extension=memcached.so</span>php.ini中添加扩展
#>3.
	<span class="coderead">phpinfo()</span>可查看php.ini的位置 和 是否安装完成.' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '21', '21', '#>1
        <div class="coderead">sudo apt-get install redis-server php-redis</div>
#>2
        <span class="coderead">extension=redis.so</span>php.ini中添加扩展
#>3
        <span class="coderead"> extension＝igbinary.so</span>如果不行再在前面加上' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '22', '22', '编辑.git/config 修改为为  <span class="coderead">http://用户名:密码@地址</span>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '23', '23', '<div class="coderead">
/home/git/.ssh 755 
/home/git/.ssh/authorized 644
</div>
参考<a href="http://www.runoob.com/git/git-server.html">http://www.runoob.com/git/git-server.html</a>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '24', '24', '修改  .gitignore
<span class="coderead">git rm -r --cached .  </span> //是目录当前下的所有,也可以单文件 
<span class="coderead">git add .   </span>//重新添加追踪
<span class="coderead">git commit -m "msg" </span> //提交 
<span class="coderead">git push origin master  </span>// 推送  ' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '25', '25', '#>1 一条命令搞定
  <div class="coderead">snap install nextcloud.</div>
  打完收功，坐等完成!
#>2目录说明-仅供学习了解，可以不看。
  nextcloud snap包含以下组件:
<div class="coderead">
  Nextcloud 12.0.5
  Apache 2.4
  PHP 7.1
  MySQL 5.7
  Redis 3.2
  mDNS用于网络发现
</div>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '26', '26', '#>0
  用电脑的屏幕看手机,并操作手机是件很爽的事情,但是不同的电脑,不同的手机就有很多不同的办法.
#>1.scrcpy 在Linux/Ubuntu/Mac电脑操作android安卓手机.
<span class="coderead">sudo apt[brew|yum] python-pip </span>//需要python环境和pip包管理工具
<span class="coderead">pip install scrcpy</span>
   
#>2.Quicktime player, Mac对ios专用,
  什么都不用安装,直接点几下就能看,对,是看,只能看不能操作手机.
  #>2>1.
  	打开Quicktime player
  #>2>2.
  	点左上角文件 
  #>2>3.
  	再点新建影像录制
  #>2>4.
  	看到了自己,哈哈, 别急, 视频中红点右边 v 下箭头点一下.看到你的手机的名字了吧.
  #>2>5.
  	选你的手机！成功结束
#>3.手机开发或测试工具,针对几乎所用常用电脑和常见手机可用.
    这是一个复杂且有技术含量的方法,我想看到这里并且想用这方法的人,一定是自己有信心有把握搭建一套移动开发和测试的环境,即所谓移动开发者的真机调试模式.另开文章讲
  #>3>1.
    <a href="/Mobile-Ios-Android-airtest-自动化移动测试工具使用心得.html">Mobile-Ios-Android-airtest-自动化移动测试工具使用心得</a>
  #>3>2.
    <a href="http://appium.io/docs/en/about-appium/getting-started/?lang=zh">Appium移动爬虫神器的官方使用说明</a>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '27', '27', '#>0
  当你开启log-bin之后,无法重启mysql，请看一下mysql日志，如果提示没有变量，那可能是全局变量不能你定义.
#>1.不要改mysql的全局变量
<span class="coderead">log_bin=mysql-bin</span> //只指定一个变量，就把basename/index/这两个都使用mysql默认的全局变量，咱们不改了， 就不会报错了。
   
#>2.这些变量还是可用的
  <div class="coderead">
  server-id=1
  log_bin=mysql-bin
  log_error=mysql-bin.err
  lower_case_table_names=1
  binlog-ignore-db=mysql,information_schema,performance_schema,sys
  binlog-do-db=cloud,thinkadmin,pandapay,datamoney
  </div>
  #>3.好学的小伙伴们 走你～
    <a href="https://dev.mysql.com/doc/mysqld-version-reference/en/optvar.html">Mysql官方对变量的详细解释说明</a>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '28', '28', '#>1.表操作
  创建表
  <span class="coderead">create table tablename(field1 varchar(50), field2 int(10))</span>
  使用旧表创建新表
  <span class="coderead">create table newtable like oldtable</span>
  <span class="coderead">create table 表名 as select 列1, 列2... from 旧表 definition only</span>
  删除表
  <span class="coderead">drop table 表名</span>
  显示所有表
  <span class="coderead">show tables</span>
  显示表详情
  <span class="coderead">desc 表名</span>
  <span class="coderead">show create table 表名</span>
  清空表
  <span class="coderead">truncate table 表名</span>
  <span class="coderead">delete from 表名</span>
  修改表名
  <span class="coderead">alter table 原名 rename to 新名</span>
  添加列
  <span class="coderead">alter table 表名 add column 列名 类型</span>
  删除列
  <span class="coderead">alter table 表名 drop column 列名</span>
  修改列名
  <span class="coderead">alter table 表名 change 原名 新名 类型</span> 
  修改列类型
  <span class="coderead">alter table 表名 modify 列名 类型</span>
  更新数据
  <span class="coderead">update 表名 set 字段=值 where 条件</span>
  删除数据
  <span class="coderead">delete from 表名 where 条件</span>
  插入数据
  <span class="coderead">insert into 表名(字段1, 字段2...) values(值1, 值2...)</span>
  排序
  <span class="coderead">select * from 表名 order by 字段 [desc|asc]</span>
  计数行
  <span class="coderead">select count(*) from 表名</span>
#>2.数据库
  创建数据库
  <span class="coderead">create database 库名</span>
  删除数据库
  <span class="coderead">drop database 库名</span>
 导出命令
  <span class="coderead">mysqldump -uroot -p123456  --lock-all-tables --flush-logs yourdbname > yourdbname_2019.sql</span>
  导入命令-先登陆进入mysql
  <span class="coderead">source $path/yourdbname_2019.sql</span>' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '29', '29', '#>1.基本知识
  #>1>1.
    mysql的编译安装
  #>1>2.
    可考虑阅读:<a href="/Mysql-Sql-常用操作.html">Mysql-Sql-常用操作</a>
  #>1>2.
    mysql 第3方存储引擎安装配置方法
  #>1>3.
    mysql 主流存储引擎(MyISAM/innodb/MEMORY)的特点
  #>1>4.
    字符串编码知识
  #>1>5.
    MySQL用户账户管理
  #>1>6.
    数据备份/数据入导出
  #>1>7.
    mysql 支持的基本数据类型
  #>1>8.
    库/表/字段/索引 的创建/修改/删除
  #>1>9.
    基本sql 语法：select/insert/update/delete,掌握最基本的语法即可
    什么inner join,left join的了解就行
    mysql的应用场景大多都是高并发访问/业务逻辑简单
    join/子查询/视图/触发器基本上不用
  #>1>10.
    sql 聚集查询：group by/having
  #>1>11.
    如何用explain 分析优化查询
  #>1>12
    常见 sql 优化技巧
    a).select xx from yyy limited ...,
    b).order by random
    c).select count(*) from
  #>1>13
    各种show xxx 指令,大概有20种,每个都尝试用一次
  #>1>14
    <span class="coderead">show VARIABLES;</span>大概有240项,逐条看懂,可以打印出来贴墙上
#>2.高级操作
  #>2>1.
    Mysql 主从同步配置
  #>2>2.
    Mysql 双master 配置
  #>2>3.
    Mysql 双master+丛库+keepalived 配置高可用数据库

#>3.客户端
  作为DBA,一定不要用各种GUI工具,mysql自带命令行client才是你的最佳武器

#>4.可选项
  #>4>1.
    mysql 分区配置,因为限制太多,实际中分表都是程序做
  #>4>2.
    高性能 mysql
    a).drizzle
    b).MariaDB
    c).handlersocket,吹牛逼用,实际工作也很难用上
    因为性能从来都不是问题,凡是采用各种“ 奇巧淫技”的项目必然是天坑
    人民群众喜闻乐用的产品都是老老实实采用最简单朴素技术实现

#>5.其他说明
  ok,耐着性子20天学完,你就能胜任主流互联网公司Mysql DBA工作
  亿万用户海量计算,只是一种经历,你在现场你就会有.
  DBA只是一个"看门狗"的角色:有事能打电话找到人,出了事故有人可以被罚款,没事就一边凉快去.
  本文大部分来自网上前辈,不记得出处了,在此声明如有侵权等相关问题请联系我删除
' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '30', '30', '#>0.
  mysql备份基本两种思路,一是a机导出a.sql.然后从b机导入a.sql.二是利用binlog 把a机的操作日志到b操作执行一次,主从读写分离等同步操作会用第二种参考：<a href="/Linux-Mysql-数据库主从配置的关键说明.html">Linux-Mysql-数据库主从配置的关键说明</a>

#>1.预习主要命令
  导出命令
  <div class="coderead">mysqldump -uroot -p123456  --lock-all-tables --flush-logs yourdbname > yourdbname_2019.sql</div>
  导入命令-先登陆进入mysql
  <div class="coderead">source $path/yourdbname_2019.sql</div>
#>2.一键脚本执行 <a href="http://datamoney.net/data/dbcopy.sh" download="dbcopy.sh">点击下载</a>
<div class="coderead">
#!/bin/bash

# 以下配置信息请自己修改
mysql_user="root" #MySQL备份用户
mysql_password="pwd123!@#" #MySQL备份用户的密码
mysql_host="192.168.254.200"
mysql_port="3306"
mysql_charset="utf8" #MySQL编码
backup_db_arr=("newpay30") #要备份的数据库名称,多个用空格分开隔开 如("db1" "db2" "db3")
backup_location=~/sqlbackup/  #备份数据存放位置,末尾请不要带"/",此项可以保持默认,程序会自动创建文件夹
expire_backup_delete="ON" #是否开启过期备份删除 ON为开启 OFF为关闭
expire_days=30 #过期时间天数 默认为三天,此项只有在expire_backup_delete开启时有效

# 本行开始以下不需要修改
backup_time=`date +%Y%m%d%H%M`  #定义备份详细时间
backup_Ymd=`date +%Y-%m-%d` #定义备份目录中的年月日时间
backup_3ago=`date -d \'3 days ago\' +%Y-%m-%d` #3天之前的日期
backup_dir=$backup_location/$backup_Ymd  #备份文件夹全路径
welcome_msg="Welcome to use MySQL backup tools!" #欢迎语

# 判断MYSQL是否启动,mysql没有启动则备份退出
mysql_ps=`ps -ef |grep mysql |wc -l`
mysql_listen=`netstat -an |grep LISTEN |grep $mysql_port|wc -l`
if [ [$mysql_ps == 0] -o [$mysql_listen == 0] ]; then
        echo "ERROR:MySQL is not running! backup stop!"
        exit
else
        echo $welcome_msg
fi

# 连接到mysql数据库,无法连接则备份退出
mysql -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password <<end
use mysql;
select host,user from user where user=\'root\' and host=\'localhost\';
exit
end

flag=`echo $?`
if [ $flag != "0" ]; then
        echo "ERROR:Can\'t connect mysql server! backup stop!"
        exit
else
        echo "MySQL connect ok! Please wait......"
        # 判断有没有定义备份的数据库,如果定义则开始备份,否则退出备份
        if [ "$backup_db_arr" != "" ];then
                #dbnames=$(cut -d \',\' -f1-5 $backup_database)
                #echo "arr is (${backup_db_arr[@]})"
                for dbname in ${backup_db_arr[@]}
                do
                        echo "database $dbname backup start..."
                        `mkdir -p $backup_dir`
                        `mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password $dbname --default-character-set=$mysql_charset | gzip > $backup_dir/$dbname-$backup_time.sql.gz`
                        flag=`echo $?`
                        if [ $flag == "0" ];then
                                echo "database $dbname success backup to $backup_dir/$dbname-$backup_time.sql.gz"
                        else
                                echo "database $dbname backup fail!"
                        fi
                        
                done
        else
                echo "ERROR:No database to backup! backup stop"
                exit
        fi
        # 如果开启了删除过期备份,则进行删除操作
        if [ "$expire_backup_delete" == "ON" -a  "$backup_location" != "" ];then
                 #`find $backup_location/ -type d -o -type f -ctime +$expire_days -exec rm -rf {} \\;`
                 `find $backup_location/ -type d -mtime +$expire_days | xargs rm -rf`
                 echo "Expired backup data delete complete!"
        fi
        echo "All database backup success! Thank you!"
        exit
fi

</div>
#>3.加入定时任务,自动执行脚本.//示例每天是上3天自动执行
<div class="coderead">crontab -e
0 3 * * * $path/dbcopy.sql </div>
' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '31', '31', '#>1
先上份配置好的虚拟主机,下面每一个server{..}都是一台虚拟主机.<a href="http://datamoney.net/data/nginx_server.conf" download="nginx_server_conf">点击下载</a>
<div class="coderead">
  # 80端口,把这台设为默认主机,Php网站解析,拒绝.ht的访问
  server {
    listen 80;
    listen [::]:80 default_server;

    server_name datamoney.net;
    root /code/datamoney/public;

    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \\.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    location ~ /\\.ht {
        deny all;
    }
  }


  # 80端口,泛解析,多域名,转发请求到另一台服务器,请注意[*]包含所有二级但不包含一级所都是一对两个,
  server {
      listen       80;
      server_name  *.datamoney.com datamoney.com *.data.com data.com money.com *.money.com;

      location / {
              proxy_pass http://web.datamoney.net;
              proxy_set_header   Host    $host;
              proxy_set_header   X-Real-IP   $remote_addr;
              proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      }
  }

  #80端口,域名泛解析,test测试前缀的域名转发测试服务器上的指定端口
  server {
      listen       80;
      server_name  ~^test.*\\.datamoney\\.net$;

      location / {
              proxy_pass http://testserver.datamoney.net:8082;
              proxy_set_header   Host    $host;
              proxy_set_header   X-Real-IP   $remote_addr;
              proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      }
  }


  #80端口,域名泛解析,并排除测试前缀域名,其他转发到正式服务器上的指定端口/目录
  server {
      listen       80;
      server_name  ~([^test])(.*)\\.datamoney\\.net$;

      location / {
              proxy_pass http://www.datamoney.net:8089/admin/;
              proxy_set_header   Host    $host;
              proxy_set_header   X-Real-IP   $remote_addr;
              proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      }    
  }
</div>
#>2.
apache请参考:<a href="/Linux-Apache-VHOSTS-多域名多端口网站虚拟主机配置.html">Linux-Apache-VHOSTS-多域名多端口网站虚拟主机配置</a>
' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '32', '32', '#>0.
  周末总结自己的交易记录
#>1.
  最好用挂单并设置好盈损,让系统自动去执行.这样能更好的排除人的因素,验证你的趋势分析
#>2.
  大势未明确终结,不能抢反转,回调在0.38左右
#>3.
  勇于及时认输止损,英雄末路的自刎而非被杀-爆仓就是被杀
#>4.
  顺势单向做单,尽量不要双向做单,会把自己脑路搞乱,情绪会被持仓盈影亏影响而后误判走势
#>5.
  止盈止损位不要太长太大[就是太贪]
  比如:预想持仓时长=几小时内,那就看持他时长的1/5的K线,即时K或30分K分析趋势,设置该持仓时段内波幅的50%-100%的止盈止损
#>6.
  在回调时的恐慌,在回调完成时的紧张而又不知所措
#>7.
  低于50%的预期收益空间时,不要下单！不要下单！！
#>8.
  亏单对冲不推荐！！不推荐！！
  优先服从其他条件,只有冷静分析走势后,预期未变仍想坚持时.
  一直实时盯盘,在最关键的爆发点迅建平打完收功.
  千万不能慌乱,不能情绪化.只有特别精准高出收手和特别有把握的趋势才能做为例外操作
#>9.
  行情大爆发时,有较大持仓则可以进行带止盈超短单抢波段
#>10.
  尽管行情在爆发或将要爆发,依然冷静全面分析,特别是独立于盘面红绿线条之外的数据分析和逻辑分析
  (在金价即将爆发时,发现金银比例偏差拉大时做了一单）' );
REPLACE INTO `words`(`id`,`aid`,`word`) VALUES ( '33', '33', '#>0
  Pass,Sass是过气的概念,催生salesforet等百亿级公司。然而今天我要说的是，Pass,Sass不但帮企业降低开发维护成本，现在要帮企业减少开发维护的人员了[好像人员本来就成本哈～]。给你一个图形界面，不用写代码，就在网站或软件上，一顿鼠标点点拖拖加头脑风暴，就能完成App开发上线,而且是IOS/android/ipad/web全齐，还不用花钱！！细思极恐，开发这套程序的程度员，一定是挥刀自宫的武林高手 - - - - 可怕。嘿！程序员～要下岗吗？
#>1. <a href="https://www.outsystems.com/case-studies/" target="_blank"> outsystems <i class="iconfont icon-lianjie">&#160;</i></a>
<div class="coderead">
介绍：outsystems-经过几轮融资（包括KKR、高盛）估值超过10 亿美元，目前看是行业较大
费用：免费30天试用
支持: iOS，Android，Windows Phone 和 Web 等多个平台上的部署
UI设计:OutSystems分析流行热门的应用程序UI，打造了部件库，可快速添加应用程序中</div>


#>2.<a href="https://www.mendix.com" target="_blank"> mendix <i class="iconfont icon-lianjie"></i></a>
<div class="coderead">
  费用：有免费和收费
  介绍：有视频教程，没深入尝试
  支持：iOS，Android ，ipad
  UI设计：模板丰富，特别是做了行业细分
</div>

#>3. <a href="https://x.thunkable.com" target="_blank"> Thunkable <i class="iconfont icon-lianjie"></i></a>
<div class="coderead">
  费用：有免费和收费
  介绍：亲测这个注册相对简单，google app maker注册就花了10分钟，推荐！
  支持：iOS，Android 集成有应用商店发布，当然是国外的
  UI设计：没发现模板，但组件库丰富，有设计或产品基础的人会喜欢
</div>

#>4. <a href="https://www.appsheet.com" target="_blank"> AppSheet <i class="iconfont icon-lianjie"></i></a>
<div class="coderead">
  费用：收费
  介绍：集成了自然语言处理，但不支持中文，提供很多云数据库的接口
  支持：iOS，Android ，ipad
  UI设计：模板丰富，特别是做了行业细分
</div>

#>5. <a href="https://developers.google.com/appmaker/" target="_blank">  <i class="iconfont icon-lianjie"></i>google AppMaker</a>
<div class="coderead">
  费用：有免费和收费
  介绍：谷歌一向稳健风格，文档全，示例多，库和模板也比较齐全，就是注册太费劲10分钟还在让我填资料，放弃尝试。
  支持：iOS，Android ，ipad
  UI设计：模板丰富，特别是做了行业细分
</div>
#>6.  <a href="https://powerapps.microsoft.com/" target="_blank">Microsoft PowerApps  <i class="iconfont icon-lianjie"></i></a>
<div class="coderead">
  费用：有免费和收费
  介绍：微软大品牌值得信赖，库和模板都有，特别他自身的优势- - -微软自有软件如办公套件集成接口，有这方面需求的你还找啥自行车。
  支持：浏览器/iOS/Android
  UI设计：模板丰富，特别是做了行业细分
</div>

#>7. <a href="https://www.dadayun.cn/index" target="_blank"> 搭搭云 <i class="iconfont icon-lianjie"></i></a>
<div class="coderead">
  费用：收费
  介绍：国人开发有中国特色的微信小程序
  支持：微信公众号、APP、PC端和小程序
  UI设计：ORM/ERP等企业级后台模板比较丰富
</div>

#>8. <a href="http://www.clickpaas.com" target="_blank"> Clickpaas <i class="iconfont icon-lianjie"></i></a>
<div class="coderead">
  费用：不详
  介绍：应该是2B(TO BUSSINESS)企业级商业使用，因为官网除了广告，没有用的信息，也没尝试入口。国人开发才支持下，否则这种2B产品这没法发表出来。
  支持：不详
  UI设计：不详
</div>' );
COMMIT;
/*!40000 ALTER TABLE `words` ENABLE KEYS */

UNLOCK TABLES;

-- ---------------------------------------------------------


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- ---------------------------------------------------------


