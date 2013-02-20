#
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# DB init script
#

DROP SCHEMA IF EXISTS `batch_db`;
CREATE SCHEMA `batch_db`
  DEFAULT CHARACTER SET utf8;
USE `batch_db`;

#
# Quartz tables, indexes etc.
#

DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

CREATE TABLE QRTZ_JOB_DETAILS (
  SCHED_NAME        VARCHAR(120) NOT NULL,
  JOB_NAME          VARCHAR(200) NOT NULL,
  JOB_GROUP         VARCHAR(200) NOT NULL,
  DESCRIPTION       VARCHAR(250) NULL,
  JOB_CLASS_NAME    VARCHAR(250) NOT NULL,
  IS_DURABLE        VARCHAR(1)   NOT NULL,
  IS_NONCONCURRENT  VARCHAR(1)   NOT NULL,
  IS_UPDATE_DATA    VARCHAR(1)   NOT NULL,
  REQUESTS_RECOVERY VARCHAR(1)   NOT NULL,
  JOB_DATA          BLOB         NULL,
  PRIMARY KEY (SCHED_NAME, JOB_NAME, JOB_GROUP))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_TRIGGERS (
  SCHED_NAME     VARCHAR(120) NOT NULL,
  TRIGGER_NAME   VARCHAR(200) NOT NULL,
  TRIGGER_GROUP  VARCHAR(200) NOT NULL,
  JOB_NAME       VARCHAR(200) NOT NULL,
  JOB_GROUP      VARCHAR(200) NOT NULL,
  DESCRIPTION    VARCHAR(250) NULL,
  NEXT_FIRE_TIME BIGINT(13)   NULL,
  PREV_FIRE_TIME BIGINT(13)   NULL,
  PRIORITY       INTEGER      NULL,
  TRIGGER_STATE  VARCHAR(16)  NOT NULL,
  TRIGGER_TYPE   VARCHAR(8)   NOT NULL,
  START_TIME     BIGINT(13)   NOT NULL,
  END_TIME       BIGINT(13)   NULL,
  CALENDAR_NAME  VARCHAR(200) NULL,
  MISFIRE_INSTR  SMALLINT(2)  NULL,
  JOB_DATA       BLOB         NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  INDEX (SCHED_NAME, JOB_NAME, JOB_GROUP),
  FOREIGN KEY (SCHED_NAME, JOB_NAME, JOB_GROUP)
  REFERENCES QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
  SCHED_NAME      VARCHAR(120) NOT NULL,
  TRIGGER_NAME    VARCHAR(200) NOT NULL,
  TRIGGER_GROUP   VARCHAR(200) NOT NULL,
  REPEAT_COUNT    BIGINT(7)    NOT NULL,
  REPEAT_INTERVAL BIGINT(12)   NOT NULL,
  TIMES_TRIGGERED BIGINT(10)   NOT NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  INDEX (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_CRON_TRIGGERS (
  SCHED_NAME      VARCHAR(120) NOT NULL,
  TRIGGER_NAME    VARCHAR(200) NOT NULL,
  TRIGGER_GROUP   VARCHAR(200) NOT NULL,
  CRON_EXPRESSION VARCHAR(120) NOT NULL,
  TIME_ZONE_ID    VARCHAR(80),
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  INDEX (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_SIMPROP_TRIGGERS
(
  SCHED_NAME    VARCHAR(120)   NOT NULL,
  TRIGGER_NAME  VARCHAR(200)   NOT NULL,
  TRIGGER_GROUP VARCHAR(200)   NOT NULL,
  STR_PROP_1    VARCHAR(512)   NULL,
  STR_PROP_2    VARCHAR(512)   NULL,
  STR_PROP_3    VARCHAR(512)   NULL,
  INT_PROP_1    INT            NULL,
  INT_PROP_2    INT            NULL,
  LONG_PROP_1   BIGINT         NULL,
  LONG_PROP_2   BIGINT         NULL,
  DEC_PROP_1    NUMERIC(13, 4) NULL,
  DEC_PROP_2    NUMERIC(13, 4) NULL,
  BOOL_PROP_1   VARCHAR(1)     NULL,
  BOOL_PROP_2   VARCHAR(1)     NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_BLOB_TRIGGERS (
  SCHED_NAME    VARCHAR(120) NOT NULL,
  TRIGGER_NAME  VARCHAR(200) NOT NULL,
  TRIGGER_GROUP VARCHAR(200) NOT NULL,
  BLOB_DATA     BLOB         NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  INDEX (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
  FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
  REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_CALENDARS (
  SCHED_NAME    VARCHAR(120) NOT NULL,
  CALENDAR_NAME VARCHAR(200) NOT NULL,
  CALENDAR      BLOB         NOT NULL,
  PRIMARY KEY (SCHED_NAME, CALENDAR_NAME))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
  SCHED_NAME    VARCHAR(120) NOT NULL,
  TRIGGER_GROUP VARCHAR(200) NOT NULL,
  PRIMARY KEY (SCHED_NAME, TRIGGER_GROUP))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_FIRED_TRIGGERS (
  SCHED_NAME        VARCHAR(120) NOT NULL,
  ENTRY_ID          VARCHAR(95)  NOT NULL,
  TRIGGER_NAME      VARCHAR(200) NOT NULL,
  TRIGGER_GROUP     VARCHAR(200) NOT NULL,
  INSTANCE_NAME     VARCHAR(200) NOT NULL,
  FIRED_TIME        BIGINT(13)   NOT NULL,
  PRIORITY          INTEGER      NOT NULL,
  STATE             VARCHAR(16)  NOT NULL,
  JOB_NAME          VARCHAR(200) NULL,
  JOB_GROUP         VARCHAR(200) NULL,
  IS_NONCONCURRENT  VARCHAR(1)   NULL,
  REQUESTS_RECOVERY VARCHAR(1)   NULL,
  PRIMARY KEY (SCHED_NAME, ENTRY_ID))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_SCHEDULER_STATE (
  SCHED_NAME        VARCHAR(120) NOT NULL,
  INSTANCE_NAME     VARCHAR(200) NOT NULL,
  LAST_CHECKIN_TIME BIGINT(13)   NOT NULL,
  CHECKIN_INTERVAL  BIGINT(13)   NOT NULL,
  PRIMARY KEY (SCHED_NAME, INSTANCE_NAME))
  ENGINE = InnoDB;

CREATE TABLE QRTZ_LOCKS (
  SCHED_NAME VARCHAR(120) NOT NULL,
  LOCK_NAME  VARCHAR(40)  NOT NULL,
  PRIMARY KEY (SCHED_NAME, LOCK_NAME))
  ENGINE = InnoDB;

CREATE INDEX IDX_QRTZ_J_REQ_RECOVERY ON QRTZ_JOB_DETAILS (SCHED_NAME, REQUESTS_RECOVERY);
CREATE INDEX IDX_QRTZ_J_GRP ON QRTZ_JOB_DETAILS (SCHED_NAME, JOB_GROUP);

CREATE INDEX IDX_QRTZ_T_J ON QRTZ_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_T_JG ON QRTZ_TRIGGERS (SCHED_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_T_C ON QRTZ_TRIGGERS (SCHED_NAME, CALENDAR_NAME);
CREATE INDEX IDX_QRTZ_T_G ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);
CREATE INDEX IDX_QRTZ_T_STATE ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_N_STATE ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_N_G_STATE ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_NEXT_FIRE_TIME ON QRTZ_TRIGGERS (SCHED_NAME, NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_ST ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE, NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_MISFIRE ON QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE ON QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE_GRP ON QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_GROUP, TRIGGER_STATE);

CREATE INDEX IDX_QRTZ_FT_TRIG_INST_NAME ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME);
CREATE INDEX IDX_QRTZ_FT_INST_JOB_REQ_RCVRY ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME, REQUESTS_RECOVERY);
CREATE INDEX IDX_QRTZ_FT_J_G ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_FT_JG ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_FT_T_G ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);
CREATE INDEX IDX_QRTZ_FT_TG ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);

#
# Test application tables, indexes etc.
#

CREATE TABLE `SBQ_USER` (
  `USER_ID` INT         NOT NULL AUTO_INCREMENT,
  `LOGIN`   VARCHAR(45) NOT NULL,
  `CREATED` DATETIME    NOT NULL,
  PRIMARY KEY (`USER_ID`),
  UNIQUE INDEX `login_UNIQUE` (`LOGIN` ASC));

INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user1', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user2', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user3', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user4', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user5', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user6', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user7', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user8', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user9', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user10', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user11', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user12', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user13', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user14', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user15', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user16', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user17', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user18', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user19', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user20', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user01', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user02', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user03', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user04', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user05', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user06', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user07', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user08', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user09', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user010', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user011', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user012', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user013', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user014', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user015', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user016', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user017', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user018', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user019', NOW());
INSERT INTO `SBQ_USER` (`LOGIN`, `CREATED`) VALUES ('user020', NOW());

CREATE TABLE `SBQ_USER_SESSION` (
  `USER_SESSION_ID` INT         NOT NULL AUTO_INCREMENT,
  `USER_ID`         INT         NOT NULL,
  `SESSION_ID`      VARCHAR(64) NOT NULL,
  `START_TIME`      DATETIME    NOT NULL,
  `END_TIME`        DATETIME    NULL DEFAULT NULL,
  PRIMARY KEY (`USER_SESSION_ID`),
  INDEX `FK_USER_ID_IDX` (`USER_ID` ASC),
  CONSTRAINT `FK_USER_ID`
  FOREIGN KEY (`USER_ID`)
  REFERENCES `SBQ_USER` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `SBQ_USER_ACTION` (
  `USER_ACTION_ID`  INT         NOT NULL AUTO_INCREMENT,
  `USER_SESSION_ID` INT         NOT NULL,
  `ACTION`          VARCHAR(45) NOT NULL,
  `CREATED`         DATETIME    NOT NULL,
  PRIMARY KEY (`USER_ACTION_ID`),
  INDEX `FK_USER_SESSION_ID_IDX` (`USER_SESSION_ID` ASC),
  CONSTRAINT `FK_USER_SESSION_ID`
  FOREIGN KEY (`USER_SESSION_ID`)
  REFERENCES `SBQ_USER_SESSION` (`USER_SESSION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

COMMIT;