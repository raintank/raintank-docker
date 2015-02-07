PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE `migration_log` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `migration_id` TEXT NOT NULL
, `sql` TEXT NOT NULL
, `success` INTEGER NOT NULL
, `error` TEXT NOT NULL
, `timestamp` DATETIME NOT NULL
);
INSERT INTO "migration_log" VALUES(1,'create migration_log table','CREATE TABLE IF NOT EXISTS `migration_log` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `migration_id` TEXT NOT NULL
, `sql` TEXT NOT NULL
, `success` INTEGER NOT NULL
, `error` TEXT NOT NULL
, `timestamp` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(2,'create user table','CREATE TABLE IF NOT EXISTS `user` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `login` TEXT NOT NULL
, `email` TEXT NOT NULL
, `name` TEXT NULL
, `password` TEXT NULL
, `salt` TEXT NULL
, `company` TEXT NULL
, `account_id` INTEGER NOT NULL
, `is_admin` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(3,'add unique index user.login','CREATE UNIQUE INDEX `UQE_user_login` ON `user` (`login`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(4,'add unique index user.email','CREATE UNIQUE INDEX `UQE_user_email` ON `user` (`email`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(5,'add column user.rands','alter table user ADD COLUMN `rands` TEXT NULL ',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(6,'create account table','CREATE TABLE IF NOT EXISTS `account` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(7,'add unique index account.name','CREATE UNIQUE INDEX `UQE_account_name` ON `account` (`name`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(8,'create account_user table','CREATE TABLE IF NOT EXISTS `account_user` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `role` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(9,'add unique index account_user_aid_uid','CREATE UNIQUE INDEX `UQE_account_user_aid_uid` ON `account_user` (`account_id`,`user_id`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(10,'create dashboard table','CREATE TABLE IF NOT EXISTS `dashboard` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `slug` TEXT NOT NULL
, `title` TEXT NOT NULL
, `data` TEXT NOT NULL
, `account_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(11,'create dashboard_tag table','CREATE TABLE IF NOT EXISTS `dashboard_tag` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `dashboard_id` INTEGER NOT NULL
, `term` TEXT NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(12,'add index dashboard.account_id','CREATE INDEX `IDX_dashboard_account_id` ON `dashboard` (`account_id`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(13,'add unique index dashboard_account_id_slug','CREATE UNIQUE INDEX `UQE_dashboard_account_id_slug` ON `dashboard` (`account_id`,`slug`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(14,'add unique index dashboard_tag.dasboard_id_term','CREATE UNIQUE INDEX `UQE_dashboard_tag_dashboard_id_term` ON `dashboard_tag` (`dashboard_id`,`term`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(15,'create data_source table','CREATE TABLE IF NOT EXISTS `data_source` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `type` TEXT NOT NULL
, `name` TEXT NOT NULL
, `access` TEXT NOT NULL
, `url` TEXT NOT NULL
, `password` TEXT NULL
, `user` TEXT NULL
, `database` TEXT NULL
, `basic_auth` INTEGER NOT NULL
, `basic_auth_user` TEXT NULL
, `basic_auth_password` TEXT NULL
, `is_default` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(16,'add index data_source.account_id','CREATE INDEX `IDX_data_source_account_id` ON `data_source` (`account_id`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(17,'add unique index data_source.account_id_name','CREATE UNIQUE INDEX `UQE_data_source_account_id_name` ON `data_source` (`account_id`,`name`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(18,'create api_key table','CREATE TABLE IF NOT EXISTS `api_key` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `name` TEXT NOT NULL
, `key` TEXT NOT NULL
, `role` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(19,'add index api_key.account_id','CREATE INDEX `IDX_api_key_account_id` ON `api_key` (`account_id`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(20,'add index api_key.key','CREATE UNIQUE INDEX `UQE_api_key_key` ON `api_key` (`key`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(21,'create location table','CREATE TABLE IF NOT EXISTS `location` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `slug` TEXT NOT NULL
, `name` TEXT NOT NULL
, `country` TEXT NOT NULL
, `region` TEXT NOT NULL
, `provider` TEXT NOT NULL
, `public` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(22,'add unique index location.account_id_slug','CREATE UNIQUE INDEX `UQE_location_account_id_slug` ON `location` (`account_id`,`slug`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(23,'create monitor_type table','CREATE TABLE IF NOT EXISTS `monitor_type` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `panel_template` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(24,'create monitor_type_setting table','CREATE TABLE IF NOT EXISTS `monitor_type_setting` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `monitor_type_id` INTEGER NOT NULL
, `variable` TEXT NOT NULL
, `description` TEXT NULL
, `data_type` TEXT NOT NULL
, `conditions` TEXT NOT NULL
, `default_value` TEXT NOT NULL
, `required` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(25,'add index monitor_type_setting.monitor_type_id','CREATE INDEX `IDX_monitor_type_setting_monitor_type_id` ON `monitor_type_setting` (`monitor_type_id`);',1,'','2015-01-28 01:45:35');
INSERT INTO "migration_log" VALUES(26,'create monitor table','CREATE TABLE IF NOT EXISTS `monitor` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `slug` TEXT NOT NULL
, `name` TEXT NOT NULL
, `monitor_type_id` INTEGER NOT NULL
, `offset` INTEGER NOT NULL
, `frequency` INTEGER NOT NULL
, `enabled` INTEGER NOT NULL
, `settings` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);',1,'','2015-01-28 01:45:36');
INSERT INTO "migration_log" VALUES(27,'add index monitor.monitor_type_id','CREATE INDEX `IDX_monitor_monitor_type_id` ON `monitor` (`monitor_type_id`);',1,'','2015-01-28 01:45:36');
INSERT INTO "migration_log" VALUES(28,'add unique index monitor.account_id_slug','CREATE UNIQUE INDEX `UQE_monitor_account_id_slug` ON `monitor` (`account_id`,`slug`);',1,'','2015-01-28 01:45:36');
INSERT INTO "migration_log" VALUES(29,'create monitor_location table','CREATE TABLE IF NOT EXISTS `monitor_location` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `monitor_id` INTEGER NOT NULL
, `location_id` INTEGER NOT NULL
);',1,'','2015-01-28 01:45:36');
INSERT INTO "migration_log" VALUES(30,'add index monitor_location.monitor_id_location_id','CREATE INDEX `IDX_monitor_location_monitor_id_location_id` ON `monitor_location` (`monitor_id`,`location_id`);',1,'','2015-01-28 01:45:36');
CREATE TABLE `user` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `login` TEXT NOT NULL
, `email` TEXT NOT NULL
, `name` TEXT NULL
, `password` TEXT NULL
, `salt` TEXT NULL
, `company` TEXT NULL
, `account_id` INTEGER NOT NULL
, `is_admin` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
, `rands` TEXT NULL);
INSERT INTO "user" VALUES(1,'admin','admin@localhost','','73aac03ba59fe3c847ee831b2f93906cd7b8620e60e39ea362002a3df747160e34a57754a98da36b4d2e0b7368d824e3b019','dQK8JbBa3r','',1,1,'2015-01-28 01:45:36','2015-01-28 01:45:36','6ACys2qD2G');
CREATE TABLE `account` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO "account" VALUES(1,'main','2015-01-28 01:45:36','2015-01-28 01:45:36');
CREATE TABLE `account_user` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `user_id` INTEGER NOT NULL
, `role` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO "account_user" VALUES(1,1,1,'Admin','2015-01-28 01:45:36','2015-01-28 01:45:36');
CREATE TABLE `dashboard` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `slug` TEXT NOT NULL
, `title` TEXT NOT NULL
, `data` TEXT NOT NULL
, `account_id` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
CREATE TABLE `dashboard_tag` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `dashboard_id` INTEGER NOT NULL
, `term` TEXT NOT NULL
);
CREATE TABLE `data_source` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `type` TEXT NOT NULL
, `name` TEXT NOT NULL
, `access` TEXT NOT NULL
, `url` TEXT NOT NULL
, `password` TEXT NULL
, `user` TEXT NULL
, `database` TEXT NULL
, `basic_auth` INTEGER NOT NULL
, `basic_auth_user` TEXT NULL
, `basic_auth_password` TEXT NULL
, `is_default` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
CREATE TABLE `api_key` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `name` TEXT NOT NULL
, `key` TEXT NOT NULL
, `role` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO "api_key" VALUES(1,1,'collector','3wJvQ3G7dZ0ZPGGAk1f2dEqSSLNl3MWGccj5Mm6w22Y2Iy0L1Xp8QH9WplfYV7Gd','RaintankAdmin','2015-01-30 01:27:19','2015-01-30 01:27:19');
CREATE TABLE `location` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `slug` TEXT NOT NULL
, `name` TEXT NOT NULL
, `country` TEXT NOT NULL
, `region` TEXT NOT NULL
, `provider` TEXT NOT NULL
, `public` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
CREATE TABLE `monitor_type` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `name` TEXT NOT NULL
, `panel_template` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO "monitor_type" VALUES(1,'HTTP','{"error":false,"span":4,"editable":true,"type":"graph","id":4,"datasource":"raintank","renderer":"flot","x-axis":true,"y-axis":true,"scale":1,"y_formats":["ms","bytes"],"grid":{"leftMax":null,"rightMax":null,"leftMin":null,"rightMin":null,"threshold1":null,"threshold2":null,"threshold1Color":"rgba(216, 200, 27, 0.27)","threshold2Color":"rgba(234, 112, 112, 0.22)"},"annotate":{"enable":false},"resolution":100,"lines":true,"fill":1,"linewidth":1,"points":false,"pointradius":5,"bars":false,"stack":true,"legend":{"show":true,"values":false,"min":false,"max":false,"current":false,"total":false,"avg":false},"percentage":false,"zerofill":true,"nullPointMode":"null","steppedLine":false,"tooltip":{"query_as_alias":true,"value_type":"individual","shared":true},"targets":[{"target":"aliasByNode(raintank.service.%monitor%.%location%.http.{dns,connect,send,wait,recv,dataLength}, 6)"}],"aliasColors":{"connect":"#1F78C1","send":"#447EBC","recv":"#82B5D8","wait":"#5195CE","dns":"#0A437C","dataLength":"#6D1F62"},"seriesOverrides":[{"alias":"dataLength","yaxis":2,"stack":false,"fill":0,"zindex":2},{"alias":"dns","zindex":-3},{"alias":"connect","zindex":-2},{"alias":"send","zindex":-1},{"alias":"wait","zindex":0},{"alias":"recv","zindex":1}],"title":"%location%"}','2015-01-27 17:53:03','2015-01-27 17:53:03');
CREATE TABLE `monitor_type_setting` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `monitor_type_id` INTEGER NOT NULL
, `variable` TEXT NOT NULL
, `description` TEXT NULL
, `data_type` TEXT NOT NULL
, `conditions` TEXT NOT NULL
, `default_value` TEXT NOT NULL
, `required` INTEGER NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
INSERT INTO "monitor_type_setting" VALUES(1,1,'host','Hostname','String','{}','',1,'2015-01-27 17:54:13','2015-01-27 17:54:13');
INSERT INTO "monitor_type_setting" VALUES(2,1,'path','Path','String','{}','/',1,'2015-01-27 17:54:32','2015-01-27 17:54:32');
INSERT INTO "monitor_type_setting" VALUES(3,1,'port','Port','Number','{}','80',0,'2015-01-27 17:54:51','2015-01-27 17:54:51');
CREATE TABLE `monitor` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `account_id` INTEGER NOT NULL
, `slug` TEXT NOT NULL
, `name` TEXT NOT NULL
, `monitor_type_id` INTEGER NOT NULL
, `offset` INTEGER NOT NULL
, `frequency` INTEGER NOT NULL
, `enabled` INTEGER NOT NULL
, `settings` TEXT NOT NULL
, `created` DATETIME NOT NULL
, `updated` DATETIME NOT NULL
);
CREATE TABLE `monitor_location` (
`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, `monitor_id` INTEGER NOT NULL
, `location_id` INTEGER NOT NULL
);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('migration_log',30);
INSERT INTO "sqlite_sequence" VALUES('account',1);
INSERT INTO "sqlite_sequence" VALUES('user',1);
INSERT INTO "sqlite_sequence" VALUES('account_user',1);
INSERT INTO "sqlite_sequence" VALUES('monitor_type',1);
INSERT INTO "sqlite_sequence" VALUES('monitor_type_setting',3);
INSERT INTO "sqlite_sequence" VALUES('location',2);
INSERT INTO "sqlite_sequence" VALUES('monitor',1);
INSERT INTO "sqlite_sequence" VALUES('monitor_location',3);
CREATE UNIQUE INDEX `UQE_user_login` ON `user` (`login`);
CREATE UNIQUE INDEX `UQE_user_email` ON `user` (`email`);
CREATE UNIQUE INDEX `UQE_account_name` ON `account` (`name`);
CREATE UNIQUE INDEX `UQE_account_user_aid_uid` ON `account_user` (`account_id`,`user_id`);
CREATE INDEX `IDX_dashboard_account_id` ON `dashboard` (`account_id`);
CREATE UNIQUE INDEX `UQE_dashboard_account_id_slug` ON `dashboard` (`account_id`,`slug`);
CREATE UNIQUE INDEX `UQE_dashboard_tag_dashboard_id_term` ON `dashboard_tag` (`dashboard_id`,`term`);
CREATE INDEX `IDX_data_source_account_id` ON `data_source` (`account_id`);
CREATE UNIQUE INDEX `UQE_data_source_account_id_name` ON `data_source` (`account_id`,`name`);
CREATE INDEX `IDX_api_key_account_id` ON `api_key` (`account_id`);
CREATE UNIQUE INDEX `UQE_api_key_key` ON `api_key` (`key`);
CREATE UNIQUE INDEX `UQE_location_account_id_slug` ON `location` (`account_id`,`slug`);
CREATE INDEX `IDX_monitor_type_setting_monitor_type_id` ON `monitor_type_setting` (`monitor_type_id`);
CREATE INDEX `IDX_monitor_monitor_type_id` ON `monitor` (`monitor_type_id`);
CREATE UNIQUE INDEX `UQE_monitor_account_id_slug` ON `monitor` (`account_id`,`slug`);
CREATE INDEX `IDX_monitor_location_monitor_id_location_id` ON `monitor_location` (`monitor_id`,`location_id`);
COMMIT;
