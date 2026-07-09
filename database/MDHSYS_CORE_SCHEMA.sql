-- MDHSYS Hospital ERP Core Schema
-- APEX 26 Compatible Database Structure
-- Created: July 2026
-- Purpose: Complete Hospital Management System

set define off;
spool MDHSYS_SETUP.log

-- ============================================
-- SEQUENCES
-- ============================================
create sequence MDHSYS.DEPT_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 50
  increment by 1
  cache 20;

create sequence MDHSYS.EMP_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 8000
  increment by 1
  cache 20;

create sequence MDHSYS.PATIENT_SEQ
  minvalue 1
  maxvalue 999999999
  start with 1000
  increment by 1
  cache 20;

create sequence MDHSYS.BILL_SEQ
  minvalue 1
  maxvalue 999999999
  start with 1
  increment by 1
  cache 20;

-- ============================================
-- MASTER TABLES
-- ============================================

-- Department Master
create table MDHSYS.DEPT_MASTER (
  dept_code    VARCHAR2(8) primary key,
  dept_name    VARCHAR2(100) not null,
  dept_type    VARCHAR2(20),
  dept_status  VARCHAR2(1) default 'A',
  created_date DATE default sysdate,
  created_by   VARCHAR2(30),
  updated_date DATE,
  updated_by   VARCHAR2(30)
);

-- Employee Master
create table MDHSYS.EMP_MASTER (
  emp_id       VARCHAR2(8) primary key,
  emp_name     VARCHAR2(100) not null,
  emp_type     VARCHAR2(20),
  dept_code    VARCHAR2(8) references MDHSYS.DEPT_MASTER(dept_code),
  emp_status   VARCHAR2(1) default 'A',
  created_date DATE default sysdate,
  created_by   VARCHAR2(30)
);

-- Patient Master
create table MDHSYS.PATIENT_MASTER (
  patient_id     VARCHAR2(10) primary key,
  patient_name   VARCHAR2(100) not null,
  gender         VARCHAR2(1),
  dob            DATE,
  contact_no     VARCHAR2(15),
  email          VARCHAR2(100),
  address        VARCHAR2(500),
  city           VARCHAR2(50),
  patient_status VARCHAR2(1) default 'A',
  created_date   DATE default sysdate,
  created_by     VARCHAR2(30)
);

-- Patient Admission
create table MDHSYS.ADMISSION (
  admission_id   VARCHAR2(15) primary key,
  patient_id     VARCHAR2(10) references MDHSYS.PATIENT_MASTER(patient_id),
  dept_code      VARCHAR2(8) references MDHSYS.DEPT_MASTER(dept_code),
  bed_no         VARCHAR2(10),
  admission_date DATE not null,
  discharge_date DATE,
  status         VARCHAR2(20),
  created_date   DATE default sysdate,
  created_by     VARCHAR2(30)
);

-- Patient Billing
create table MDHSYS.BILLING (
  bill_id        VARCHAR2(15) primary key,
  patient_id     VARCHAR2(10) references MDHSYS.PATIENT_MASTER(patient_id),
  admission_id   VARCHAR2(15),
  bill_date      DATE not null,
  total_amount   NUMBER(13,2),
  paid_amount    NUMBER(13,2),
  balance        NUMBER(13,2),
  bill_status    VARCHAR2(20),
  created_date   DATE default sysdate,
  created_by     VARCHAR2(30)
);

-- Billing Details
create table MDHSYS.BILLING_DETAILS (
  bill_detail_id VARCHAR2(15) primary key,
  bill_id        VARCHAR2(15) references MDHSYS.BILLING(bill_id),
  service_name   VARCHAR2(100),
  quantity       NUMBER(10,2),
  unit_price     NUMBER(13,2),
  total_amount   NUMBER(13,2)
);

-- System Parameters
create table MDHSYS.SYSTEM_PARAMETERS (
  param_id       VARCHAR2(10) primary key,
  param_name     VARCHAR2(100) not null,
  param_value    VARCHAR2(4000),
  created_date   DATE default sysdate,
  updated_date   DATE
);

-- Audit Log
create table MDHSYS.AUDIT_LOG (
  audit_id       NUMBER primary key,
  action         VARCHAR2(50),
  table_name     VARCHAR2(50),
  record_id      VARCHAR2(50),
  old_value      CLOB,
  new_value      CLOB,
  user_name      VARCHAR2(30),
  log_date       DATE default sysdate
);

commit;
spool off