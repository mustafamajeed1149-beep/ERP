-- ========================================================
-- MDHSYS Hospital ERP - Complete Database Schema
-- APEX 26 Compatible
-- All Accounting & Hospital Tables
-- ========================================================

set define off;
spool MDHSYS_COMPLETE.log

-- ============================================
-- SEQUENCES
-- ============================================
create sequence MDHSYS.DEPT_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start with 50 increment by 1 cache 20;
create sequence MDHSYS.EMP_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start with 8000 increment by 1 cache 20;
create sequence MDHSYS.PATIENT_SEQ minvalue 1 maxvalue 999999999 start with 1000 increment by 1 cache 20;
create sequence MDHSYS.BILL_SEQ minvalue 1 maxvalue 999999999 start with 1 increment by 1 cache 20;

-- ============================================
-- ASSET MANAGEMENT TABLES
-- ============================================

-- Asset Read-Only Snapshot
create table MDHSYS.ACT_RO_ASSET (
  rat_cp_code  VARCHAR2(2) not null,
  rat_usr_name VARCHAR2(30) not null,
  rat_session  VARCHAR2(2) not null,
  rat_prg_code VARCHAR2(10) not null,
  rat_ast_code VARCHAR2(5) not null,
  rat_tfa_acc  VARCHAR2(8) not null,
  rat_opn_cst  NUMBER(13,2),
  rat_add_cst  NUMBER(13,2),
  rat_del_cst  NUMBER(13,2),
  rat_opn_dep  NUMBER(13,2),
  rat_del_dep  NUMBER(13,2),
  rat_prd_dep  NUMBER(13,2),
  rat_cmp_dep  NUMBER(13,2),
  rat_init_amt NUMBER(13,2),
  rat_norm_amt NUMBER(13,2),
  rat_br_code  VARCHAR2(3),
  rat_prj_code VARCHAR2(3),
  rat_dp_code  VARCHAR2(8),
  rat_seq_num  NUMBER,
  rat_cur_dep  VARCHAR2(8),
  rat_bal_cst  NUMBER(13,2),
  rat_acc_dep  NUMBER(13,2),
  rat_wrt_amt  NUMBER(13,2),
  constraint ACT_RO_ASSET_PK primary key (RAT_CP_CODE, RAT_USR_NAME, RAT_SESSION, RAT_PRG_CODE, RAT_AST_CODE, RAT_TFA_ACC)
);

-- Asset Read-Only Balance
create table MDHSYS.ACT_RO_BALANCE (
  rpt_cp_code   VARCHAR2(2) not null,
  rpt_usr_name  VARCHAR2(30) not null,
  rpt_session   VARCHAR2(2) not null,
  rpt_prg_code  VARCHAR2(10) not null,
  rpt_coa3_code VARCHAR2(10) not null,
  rpt_prj_code  VARCHAR2(3) not null,
  rpt_dp_code   VARCHAR2(7) not null,
  rpt_amt01     NUMBER(13,2),
  rpt_amt02     NUMBER(13,2),
  rpt_amt03     NUMBER(13,2),
  rpt_amt04     NUMBER(13,2),
  rpt_amt05     NUMBER(13,2),
  rpt_amt06     NUMBER(13,2),
  rpt_amt07     NUMBER(13,2),
  rpt_amt08     NUMBER(13,2),
  rpt_amt09     NUMBER(13,2),
  rpt_amt10     NUMBER(13,2),
  rpt_amt11     NUMBER(13,2),
  rpt_amt12     NUMBER(13,2),
  rpt_br_code   VARCHAR2(3),
  constraint ACT_RO_BALANCE_PK primary key (RPT_CP_CODE, RPT_USR_NAME, RPT_SESSION, RPT_PRG_CODE, RPT_COA3_CODE, RPT_PRJ_CODE, RPT_DP_CODE)
);

-- Bank Statement Read-Only
create table MDHSYS.ACT_RO_BNK_STAT (
  bnk_cp_code   VARCHAR2(2) not null,
  bnk_usr_name  VARCHAR2(30) not null,
  bnk_session   VARCHAR2(2) not null,
  bnk_prg_code  VARCHAR2(10) not null,
  bnk_coa3_code VARCHAR2(8) not null,
  bnk_mvh_num   VARCHAR2(15) not null,
  bnk_date      DATE,
  bnk_chq_num   VARCHAR2(10),
  bnk_rem       VARCHAR2(1000),
  bnk_dbt_amt   NUMBER(13,2),
  bnk_crd_amt   NUMBER(13,2),
  constraint ACT_RO_BNK_STAT_PK primary key (BNK_CP_CODE, BNK_USR_NAME, BNK_SESSION, BNK_PRG_CODE, BNK_COA3_CODE, BNK_MVH_NUM)
);

-- Cheque History Read-Only
create table MDHSYS.ACT_RO_CHQ_HIS (
  rch_cp_code   VARCHAR2(2) not null,
  rch_usr_name  VARCHAR2(30) not null,
  rch_session   VARCHAR2(2) not null,
  rch_prg_code  VARCHAR2(10) not null,
  rch_seq_no    NUMBER(6) not null,
  rch_coa3_code VARCHAR2(8) not null,
  rch_prj_code  VARCHAR2(3),
  rch_dp_code   VARCHAR2(7),
  rch_dsc01     VARCHAR2(20),
  rch_dsc02     VARCHAR2(20),
  rch_dsc03     VARCHAR2(20),
  rch_dsc04     VARCHAR2(20),
  rch_dsc05     VARCHAR2(20),
  rch_dsc06     VARCHAR2(20),
  constraint ACT_RO_CHQ_HIS_PK primary key (RCH_CP_CODE, RCH_SESSION, RCH_USR_NAME, RCH_PRG_CODE, RCH_COA3_CODE, RCH_SEQ_NO)
);

-- Cheque Print Read-Only
create table MDHSYS.ACT_RO_CHQ_PRINT (
  rpt_cp_code  VARCHAR2(2),
  rpt_mvh_num  VARCHAR2(15),
  rpt_mvh_date DATE,
  rpt_chq_date DATE,
  rpt_bnk_coa3 VARCHAR2(8),
  rpt_acc_pay  VARCHAR2(255),
  rpt_amt_wrds VARCHAR2(1000),
  rpt_amt      NUMBER(13,2),
  rpt_remarks1 VARCHAR2(100),
  rpt_remarks2 VARCHAR2(100),
  rpt_remarks3 VARCHAR2(100),
  rpt_usr_name VARCHAR2(30),
  rpt_session  VARCHAR2(2),
  rpt_prg_code VARCHAR2(10)
);

-- Expense Budget Read-Only
create table MDHSYS.ACT_RO_EXPENSE_BUDGET (
  rpt_cp_code   VARCHAR2(2),
  rpt_usr_name  VARCHAR2(30),
  rpt_session   VARCHAR2(2),
  rpt_prg_code  VARCHAR2(10),
  rpt_coa3_code VARCHAR2(10),
  rpt_month     VARCHAR2(15),
  rpt_bgt_amt   NUMBER(13,2),
  rpt_fct_amt   NUMBER(13,2),
  rpt_act_amt   NUMBER(13,2),
  rpt_bgt_act   NUMBER(13,2),
  rpt_fct_act   NUMBER(13,2),
  rpt_dp_code   VARCHAR2(6),
  rpt_prj_code  VARCHAR2(3),
  rpt_date_fm   DATE,
  rpt_date_to   DATE,
  rpt_act_desc  VARCHAR2(60),
  rpt_act_tot   NUMBER(13,2)
);

-- Financial Report Read-Only
create table MDHSYS.ACT_RO_FNCL_RPT (
  frp_cp_code   VARCHAR2(2) not null,
  frp_usr_name  VARCHAR2(30) not null,
  frp_session   VARCHAR2(2) not null,
  frp_prg_code  VARCHAR2(10) not null,
  frp_mfr_code  VARCHAR2(2) not null,
  frp_seq_num   NUMBER(4) not null,
  frp_heading   VARCHAR2(100),
  frp_fst_amt   NUMBER(13,2),
  frp_lst_amt   NUMBER(13,2),
  frp_lst_var   NUMBER(13,2),
  frp_dbg_amt   NUMBER(13,2),
  frp_dbg_var   NUMBER(13,2),
  frp_coa3_code VARCHAR2(8),
  frp_prj_code  VARCHAR2(3),
  frp_dp_code   VARCHAR2(6),
  frp_fc_amt    NUMBER(13,2),
  frp_fc_var    NUMBER(13,2),
  constraint ACT_RO_FNCL_RPT_PK primary key (FRP_CP_CODE, FRP_USR_NAME, FRP_SESSION, FRP_PRG_CODE, FRP_MFR_CODE, FRP_SEQ_NUM)
);

-- Ledger Read-Only
create table MDHSYS.ACT_RO_LEDGER (
  rpt_cp_code     VARCHAR2(2) not null,
  rpt_usr_name    VARCHAR2(30) not null,
  rpt_session     VARCHAR2(2) not null,
  rpt_prg_code    VARCHAR2(10) not null,
  rpt_coa3_code   VARCHAR2(10) not null,
  rpt_prj_code    VARCHAR2(3) not null,
  rpt_dp_code     VARCHAR2(7) not null,
  rpt_mvh_num     VARCHAR2(15) not null,
  rpt_doc_num     VARCHAR2(15) not null,
  rpt_chq_num     VARCHAR2(10) not null,
  rpt_seq_num     NUMBER(4) not null,
  rpt_date        DATE,
  rpt_type        VARCHAR2(1),
  rpt_remark      VARCHAR2(1000),
  rpt_dbt_amt     NUMBER(13,2),
  rpt_crd_amt     NUMBER(13,2),
  rpt_bal_amt     NUMBER(13,2),
  rpt_dbt_oth     NUMBER(13,2),
  rpt_crd_oth     NUMBER(13,2),
  rpt_bal_oth     NUMBER(13,2),
  rpt_mvh_num_dbc VARCHAR2(15),
  constraint ACT_RO_LEDGER_PK primary key (RPT_CP_CODE, RPT_USR_NAME, RPT_SESSION, RPT_PRG_CODE, RPT_COA3_CODE, RPT_PRJ_CODE, RPT_DP_CODE, RPT_MVH_NUM, RPT_DOC_NUM, RPT_CHQ_NUM, RPT_SEQ_NUM)
);

-- Position Read-Only
create table MDHSYS.ACT_RO_POSITION (
  rpt_cp_code  VARCHAR2(2),
  rpt_usr_name VARCHAR2(30),
  rpt_session  VARCHAR2(2),
  rpt_prg_code VARCHAR2(10),
  rpt_type     VARCHAR2(1),
  rpt_bnk_coa3 VARCHAR2(8),
  rpt_desc     VARCHAR2(500),
  rpt_amount   NUMBER(15,2)
);

-- ============================================
-- ASSET DETAIL TABLES (Transactional)
-- ============================================

-- Add Asset
create table MDHSYS.ACT_SD_ADD_ASSET (
  daa_cp_code  VARCHAR2(2) not null,
  daa_ast_code VARCHAR2(5) not null,
  daa_add_date DATE not null,
  daa_add_amt  NUMBER(13,2) not null,
  daa_remark   VARCHAR2(30),
  daa_br_code  VARCHAR2(3),
  constraint ACT_SD_ADD_ASSET_PK primary key (DAA_ADD_DATE, DAA_AST_CODE, DAA_CP_CODE)
);

-- Depreciation Detail
create table MDHSYS.ACT_SD_ADEPT (
  dad_cp_code   VARCHAR2(2) not null,
  dad_ast_code  VARCHAR2(8) not null,
  dad_dp_date   DATE not null,
  dad_prj_code  VARCHAR2(3) not null,
  dad_dp_code   VARCHAR2(6) not null,
  dad_pct       NUMBER(5,2),
  dad_loc_flag  VARCHAR2(1),
  dad_br_code   VARCHAR2(3),
  dad_ins_dtime DATE,
  dad_ins_usr   VARCHAR2(30),
  dad_upd_dtime DATE,
  dad_upd_usr   VARCHAR2(30),
  constraint ACT_SD_ADEPT_PK primary key (DAD_AST_CODE, DAD_CP_CODE, DAD_DP_DATE, DAD_PRJ_CODE, DAD_DP_CODE)
);

-- Asset Detail
create table MDHSYS.ACT_SD_ASSET (
  dat_cp_code  VARCHAR2(2) not null,
  dat_ast_code VARCHAR2(5) not null,
  dat_date     DATE not null,
  dat_mvh_num  VARCHAR2(15) not null,
  dat_dep_amt  NUMBER(13,2),
  dat_int_amt  NUMBER(13,2),
  dat_nor_amt  NUMBER(13,2),
  dat_br_code  VARCHAR2(3),
  dat_prj_code VARCHAR2(3),
  dat_dp_code  VARCHAR2(6),
  dat_seq_num  NUMBER(3),
  dat_exp_coa3 VARCHAR2(10),
  constraint ACT_SD_ASSET_PK primary key (DAT_AST_CODE, DAT_CP_CODE, DAT_DATE)
);

-- Asset Tracking
create table MDHSYS.ACT_SD_ASSET_TRACKING (
  dtr_cp_code  VARCHAR2(2) not null,
  dtr_date     DATE not null,
  dtr_ast_code VARCHAR2(8) not null,
  dtr_cst_code VARCHAR2(5),
  dtr_loc_code VARCHAR2(3),
  dtr_dp_code  VARCHAR2(6),
  dtr_remarks  VARCHAR2(500),
  dtr_trn_ref  VARCHAR2(15),
  dtr_rcp_ref  VARCHAR2(15),
  constraint ACT_SD_ASSET_TRACKING_PK primary key (DTR_CP_CODE, DTR_DATE, DTR_AST_CODE)
);

-- ============================================
-- ASSET MASTER TABLES
-- ============================================

-- Asset Master
create table MDHSYS.ACT_SM_ASSET (
  ast_cp_code     VARCHAR2(2) not null,
  ast_code        VARCHAR2(8) not null,
  ast_desc        VARCHAR2(150),
  ast_type        VARCHAR2(1),
  ast_rate        NUMBER(5,2),
  ast_date        DATE,
  ast_dsp_date    DATE,
  ast_dsp_amt     NUMBER(13,2),
  ast_year        NUMBER(2),
  ast_tfa_acc     VARCHAR2(8),
  ast_tfa_amt     NUMBER(13,2),
  ast_dep_acc     VARCHAR2(8),
  ast_exp_acc     VARCHAR2(8),
  ast_dp_date     DATE,
  ast_res_val     NUMBER(13,2),
  ast_br_code     VARCHAR2(3),
  ast_dep_amt     NUMBER(38),
  ast_ins_usr     VARCHAR2(30),
  ast_upd_usr     VARCHAR2(30),
  ast_ins_date    DATE,
  ast_upd_date    DATE,
  ast_make        VARCHAR2(30),
  ast_model       VARCHAR2(60),
  ast_srl_no      VARCHAR2(20),
  ast_owner       VARCHAR2(30),
  ast_vendor      VARCHAR2(60),
  ast_cat_code    VARCHAR2(8),
  ast_msb_flag    VARCHAR2(1),
  ast_own_type    VARCHAR2(1),
  ast_trf_type    VARCHAR2(1),
  ast_trf_rem     VARCHAR2(100),
  ast_ref_code    VARCHAR2(8),
  ast_status      VARCHAR2(1),
  ast_prc_flag    VARCHAR2(1),
  ast_po_num      VARCHAR2(15),
  ast_grn_num     VARCHAR2(15),
  ast_grn_mvh_num VARCHAR2(15),
  ast_itm_code    VARCHAR2(15),
  ast_dsp_mvh_num VARCHAR2(15),
  ast_dsp_type    VARCHAR2(1),
  ast_cor_amt     NUMBER(13,2),
  ast_dsp_rem     VARCHAR2(150),
  ast_old_code    NUMBER,
  ast_old_cat     NUMBER,
  ast_prj_code    VARCHAR2(3),
  ast_prt_code    VARCHAR2(8),
  ast_exp_date    DATE,
  ast_units       NUMBER(13,2),
  ast_capex_num   VARCHAR2(15),
  ast_trf_mvh_num VARCHAR2(15),
  ast_trf_date    DATE,
  ast_rvl_amt     NUMBER(13,2),
  ast_rtf_date    DATE,
  ast_mcw_num     VARCHAR2(15),
  ast_mcw_mvh_num VARCHAR2(15),
  ast_int_rate    NUMBER(5,2),
  constraint ACT_SM_ASSET_PK primary key (AST_CODE, AST_CP_CODE)
);

-- Asset Transfer
create table MDHSYS.ACT_SD_ATRANSFER (
  dta_cp_code  VARCHAR2(2) not null,
  dta_eff_date DATE not null,
  dta_br_code  VARCHAR2(3) not null,
  dta_ast_code VARCHAR2(8) not null,
  constraint ACT_SD_ATRANSFER_PK primary key (DTA_AST_CODE, DTA_EFF_DATE, DTA_BR_CODE, DTA_CP_CODE),
  constraint ACT_SD_ATRANSFER_FK foreign key (DTA_AST_CODE, DTA_CP_CODE) references MDHSYS.ACT_SM_ASSET (AST_CODE, AST_CP_CODE)
);

-- ============================================
-- ACCOUNTING SETUP TABLES
-- ============================================

-- Bank Setup
create table MDHSYS.ACT_SD_BANK (
  dbk_cp_code   VARCHAR2(2) not null,
  dbk_coa3_code VARCHAR2(8) not null,
  dbk_date      DATE not null,
  dbk_chq_fm    VARCHAR2(10) not null,
  dbk_chq_to    VARCHAR2(10) not null,
  dbk_br_code   VARCHAR2(3),
  constraint ACT_SD_BANK_PK primary key (DBK_COA3_CODE, DBK_CP_CODE, DBK_CHQ_FM, DBK_CHQ_TO)
);

-- Budget Setup
create table MDHSYS.ACT_SD_BUDGET (
  dbg_cp_code   VARCHAR2(2) not null,
  dbg_fyr_fm    DATE not null,
  dbg_fyr_to    DATE not null,
  dbg_coa3_code VARCHAR2(8) not null,
  dbg_prj_code  VARCHAR2(3) not null,
  dbg_dp_code   VARCHAR2(6) not null,
  dbg_amt01     NUMBER(13,2),
  dbg_amt02     NUMBER(13,2),
  dbg_amt03     NUMBER(13,2),
  dbg_amt04     NUMBER(13,2),
  dbg_amt05     NUMBER(13,2),
  dbg_amt06     NUMBER(13,2),
  dbg_amt07     NUMBER(13,2),
  dbg_amt08     NUMBER(13,2),
  dbg_amt09     NUMBER(13,2),
  dbg_amt10     NUMBER(13,2),
  dbg_amt11     NUMBER(13,2),
  dbg_amt12     NUMBER(13,2),
  dbg_famt01    NUMBER(13,2),
  dbg_famt02    NUMBER(13,2),
  dbg_famt03    NUMBER(13,2),
  dbg_famt04    NUMBER(13,2),
  dbg_famt05    NUMBER(13,2),
  dbg_famt06    NUMBER(13,2),
  dbg_famt07    NUMBER(13,2),
  dbg_famt08    NUMBER(13,2),
  dbg_famt09    NUMBER(13,2),
  dbg_famt10    NUMBER(13,2),
  dbg_famt11    NUMBER(13,2),
  dbg_famt12    NUMBER(13,2),
  constraint ACT_SD_BUDGET_PK primary key (DBG_FYR_FM, DBG_FYR_TO, DBG_CP_CODE, DBG_COA3_CODE, DBG_PRJ_CODE, DBG_DP_CODE)
);

-- Cheque Void
create table MDHSYS.ACT_SD_CHQ_VOID (
  dcv_cp_code   VARCHAR2(2) not null,
  dcv_coa3_code VARCHAR2(8) not null,
  dcv_chq_num   VARCHAR2(10) not null,
  dcv_date      DATE,
  dcv_user      VARCHAR2(30),
  dcv_br_code   VARCHAR2(3),
  constraint ACT_SD_CHQ_VOID_PK primary key (DCV_COA3_CODE, DCV_CP_CODE, DCV_CHQ_NUM)
);

-- Calendar Budget
create table MDHSYS.ACT_SD_CLNDR_BUDGET (
  dbg_cp_code   VARCHAR2(2) not null,
  dbg_year      NUMBER(4) not null,
  dbg_coa2_code VARCHAR2(4) not null,
  dbg_prj_code  VARCHAR2(3) not null,
  dbg_dp_code   VARCHAR2(6) not null,
  dbg_amt01     NUMBER(13,2),
  dbg_amt02     NUMBER(13,2),
  dbg_amt03     NUMBER(13,2),
  dbg_amt04     NUMBER(13,2),
  dbg_amt05     NUMBER(13,2),
  dbg_amt06     NUMBER(13,2),
  dbg_amt07     NUMBER(13,2),
  dbg_amt08     NUMBER(13,2),
  dbg_amt09     NUMBER(13,2),
  dbg_amt10     NUMBER(13,2),
  dbg_amt11     NUMBER(13,2),
  dbg_amt12     NUMBER(13,2),
  dbg_famt01    NUMBER(13,2),
  dbg_famt02    NUMBER(13,2),
  dbg_famt03    NUMBER(13,2),
  dbg_famt04    NUMBER(13,2),
  dbg_famt05    NUMBER(13,2),
  dbg_famt06    NUMBER(13,2),
  dbg_famt07    NUMBER(13,2),
  dbg_famt08    NUMBER(13,2),
  dbg_famt09    NUMBER(13,2),
  dbg_famt10    NUMBER(13,2),
  dbg_famt11    NUMBER(13,2),
  dbg_famt12    NUMBER(13,2),
  constraint ACT_SD_CLNDR_BUDGET_PK primary key (DBG_YEAR, DBG_CP_CODE, DBG_COA2_CODE, DBG_PRJ_CODE, DBG_DP_CODE)
);

-- COA Level 2
create table MDHSYS.ACT_SD_COA_LEVEL2 (
  coa2_code      VARCHAR2(5) not null,
  coa2_coa1_code VARCHAR2(2),
  coa2_desc      VARCHAR2(60),
  constraint ACT_SD_COA_LEVEL2_PK primary key (COA2_CODE)
);

-- COA Level 3
create table MDHSYS.ACT_SD_COA_LEVEL3 (
  coa3_cp_code       VARCHAR2(2) not null,
  coa3_coa2_code     VARCHAR2(4),
  coa3_code          VARCHAR2(9) not null,
  coa3_desc          VARCHAR2(100),
  coa3_cy_code       VARCHAR2(3),
  coa3_flag          VARCHAR2(1),
  coa3_ref_num_flag  VARCHAR2(1),
  coa3_ref_date_flag VARCHAR2(1),
  constraint ACT_SD_COA_LEVEL3_PK primary key (COA3_CODE, COA3_CP_CODE)
);

-- COA Opening Balance
create table MDHSYS.ACT_SD_COA_OPNBAL (
  dco_cp_code   VARCHAR2(2) not null,
  dco_fyr_fm    DATE not null,
  dco_fyr_to    DATE not null,
  dco_br_code   VARCHAR2(3) not null,
  dco_coa3_code VARCHAR2(8) not null,
  dco_prj_code  VARCHAR2(3) not null,
  dco_dp_code   VARCHAR2(6),
  dco_voy_num   VARCHAR2(15),
  dco_dbt_oth   NUMBER(13,2),
  dco_crd_oth   NUMBER(13,2),
  dco_dbt_amt   NUMBER(13,2),
  dco_crd_amt   NUMBER(13,2),
  constraint ACT_SD_COA_OPNBAL_PK primary key (DCO_FYR_FM, DCO_FYR_TO, DCO_CP_CODE, DCO_COA3_CODE, DCO_PRJ_CODE, DCO_BR_CODE)
);

-- Depreciation Allocation
create table MDHSYS.ACT_SD_DEP_ALLOCATION (
  dca_cp_code   VARCHAR2(2) not null,
  dca_cat_id    VARCHAR2(8) not null,
  dca_eff_date  DATE not null,
  dca_prj_code  VARCHAR2(3) not null,
  dca_dp_code   VARCHAR2(6) not null,
  dca_percent   NUMBER(5,2),
  dca_ins_user  VARCHAR2(30),
  dca_ins_dtime DATE,
  dca_upd_user  VARCHAR2(30),
  dca_upd_dtime DATE,
  constraint ACT_SD_DEP_ALLOCATION_PK primary key (DCA_CP_CODE, DCA_CAT_ID, DCA_EFF_DATE, DCA_PRJ_CODE, DCA_DP_CODE)
);

-- Disposal Voucher
create table MDHSYS.ACT_SD_DSP_VOUCHER (
  dsp_cp_code     VARCHAR2(2) not null,
  dsp_ast_code    VARCHAR2(8) not null,
  dsp_coa3_code   VARCHAR2(10) not null,
  dsp_dbt_amt     NUMBER(13,2),
  dsp_crd_amt     NUMBER(13,2),
  dsp_remarks     VARCHAR2(100),
  dsp_cost_centre VARCHAR2(6),
  dsp_flag        VARCHAR2(1),
  constraint ACT_SD_DSP_VOUCHER_PK primary key (DSP_CP_CODE, DSP_AST_CODE, DSP_COA3_CODE)
);

-- Financial Format
create table MDHSYS.ACT_SD_FORMAT (
  dfr_cp_code VARCHAR2(2) not null,
  dfr_code    VARCHAR2(2) not null,
  dfr_seq_num NUMBER(4) not null,
  dfr_status  VARCHAR2(1),
  dfr_note    VARCHAR2(2),
  dfr_heading VARCHAR2(50),
  dfr_amount  NUMBER(15,2),
  dfr_type    VARCHAR2(1),
  constraint ACT_SD_FORMAT_PK primary key (DFR_CODE, DFR_CP_CODE, DFR_SEQ_NUM)
);

-- Format Details
create table MDHSYS.ACT_SD_FORMAT_DTL (
  dfd_cp_code VARCHAR2(2) not null,
  dfd_code    VARCHAR2(2) not null,
  dfd_seq_num NUMBER(4) not null,
  dfd_coa3_fm VARCHAR2(8) not null,
  dfd_coa3_to VARCHAR2(8) not null,
  dfd_prj_fm  VARCHAR2(8) not null,
  dfd_prj_to  VARCHAR2(8) not null,
  dfd_dp_fm   VARCHAR2(6) not null,
  dfd_dp_to   VARCHAR2(6) not null,
  dfd_nature  VARCHAR2(1) not null,
  dfd_type    VARCHAR2(1) not null,
  constraint ACT_SD_FORMAT_DTL_PK primary key (DFD_CODE, DFD_CP_CODE, DFD_SEQ_NUM, DFD_COA3_FM, DFD_COA3_TO, DFD_PRJ_FM, DFD_PRJ_TO, DFD_DP_FM, DFD_DP_TO, DFD_NATURE, DFD_TYPE)
);

-- Format Totals
create table MDHSYS.ACT_SD_FORMAT_TOT (
  dft_cp_code  VARCHAR2(2) not null,
  dft_code     VARCHAR2(2) not null,
  dft_seq_num  NUMBER(4) not null,
  dft_mfr_code VARCHAR2(2) not null,
  dft_mfr_seq  NUMBER(4) not null,
  constraint ACT_SD_FORMAT_TOT_PK primary key (DFT_CODE, DFT_CP_CODE, DFT_SEQ_NUM, DFT_MFR_SEQ, DFT_MFR_CODE)
);

-- Group COA3
create table MDHSYS.ACT_SD_GRP_COA3 (
  dgp_cp_code      VARCHAR2(2) not null,
  dgp_mgp_code     VARCHAR2(8) not null,
  dgp_coa3_code_fm VARCHAR2(8) not null,
  dgp_coa3_code_to VARCHAR2(8) not null,
  dgp_dp_code_fm   VARCHAR2(6),
  dgp_dp_code_to   VARCHAR2(6),
  dgp_br_code      VARCHAR2(3),
  constraint ACT_SD_GRP_COA3_PK primary key (DGP_CP_CODE, DGP_MGP_CODE, DGP_COA3_CODE_FM, DGP_COA3_CODE_TO)
);

-- Period Budget
create table MDHSYS.ACT_SD_PRD_BUDGET (
  dbg_cp_code   VARCHAR2(2) not null,
  dbg_date_fm   DATE not null,
  dbg_date_to   DATE not null,
  dbg_coa3_code VARCHAR2(8) not null,
  dbg_prj_code  VARCHAR2(3) not null,
  dbg_dp_code   VARCHAR2(6) not null,
  dbg_bgt_amt   NUMBER(13,2),
  dbg_fct_amt   NUMBER(13,2),
  dbg_act_flag  VARCHAR2(1),
  dbg_rev_exp   VARCHAR2(1),
  constraint ACT_SD_PRD_BUDGET_PK primary key (DBG_DATE_FM, DBG_DATE_TO, DBG_CP_CODE, DBG_COA3_CODE, DBG_PRJ_CODE, DBG_DP_CODE)
);

-- Voucher
create table MDHSYS.ACT_SD_VOUCHER (
  ddv_cp_code   VARCHAR2(2) not null,
  ddv_mdv_code  VARCHAR2(15) not null,
  ddv_seq_num   NUMBER(4) not null,
  ddv_coa3_code VARCHAR2(8),
  ddv_prj_code  VARCHAR2(3),
  ddv_dp_code   VARCHAR2(6),
  ddv_dbt_amt   NUMBER(13,2),
  ddv_crd_amt   NUMBER(13,2),
  ddv_rem       VARCHAR2(1000),
  ddv_ins_date  DATE,
  ddv_ins_user  VARCHAR2(30),
  ddv_upd_date  DATE,
  ddv_upd_user  VARCHAR2(30),
  constraint ACT_SD_VOUCHER_PK primary key (DDV_MDV_CODE, DDV_CP_CODE, DDV_SEQ_NUM)
);

-- WHT Wise
create table MDHSYS.ACT_SD_WHT_PRT_WISE (
  dwp_cp_code    VARCHAR2(2) not null,
  dwp_eff_date   DATE not null,
  dwp_swh_code   VARCHAR2(5) not null,
  dwp_crd_coa_fm VARCHAR2(15),
  dwp_crd_coa_to VARCHAR2(15),
  dwp_coa        VARCHAR2(15),
  dwp_active     VARCHAR2(1),
  dwp_ins_user   VARCHAR2(50),
  dwp_ins_date   DATE,
  dwp_upd_user   VARCHAR2(50),
  dwp_upd_date   DATE,
  constraint ACT_SD_WHT_PRT_WISE_PK primary key (DWP_CP_CODE, DWP_EFF_DATE, DWP_SWH_CODE)
);

-- ============================================
-- ACCOUNTING MASTER TABLES
-- ============================================

-- Bank Master
create table MDHSYS.ACT_SM_BANK (
  bnk_cp_code   VARCHAR2(2) not null,
  bnk_coa3_code VARCHAR2(8) not null,
  bnk_acct_no   VARCHAR2(20) not null,
  bnk_add1      VARCHAR2(30),
  bnk_add2      VARCHAR2(30),
  bnk_city      VARCHAR2(30),
  bnk_tel       VARCHAR2(30),
  bnk_fax       VARCHAR2(30),
  bnk_tlx       VARCHAR2(30),
  bnk_cp_flag   VARCHAR2(1),
  bnk_cpr_name  VARCHAR2(100),
  bnk_br_code   VARCHAR2(3),
  constraint ACT_SM_BANK_PK primary key (BNK_COA3_CODE, BNK_CP_CODE)
);

-- Calendar Budget Master
create table MDHSYS.ACT_SM_CLNDR_BUDGET (
  mbg_cp_code VARCHAR2(2) not null,
  mbg_year    NUMBER(4) not null,
  constraint ACT_SM_CLNDR_BUDGET_PK primary key (MBG_YEAR, MBG_CP_CODE)
);

-- COA Level 1 Master
create table MDHSYS.ACT_SM_COA_LEVEL1 (
  coa1_code      VARCHAR2(2) not null,
  coa1_desc      VARCHAR2(30),
  coa1_type      VARCHAR2(1),
  coa1_coam_code VARCHAR2(1),
  coa1_nature    VARCHAR2(1),
  constraint ACT_SM_COA_LEVEL1_PK primary key (COA1_CODE)
);

-- COA Main Master
create table MDHSYS.ACT_SM_COA_MAIN (
  coam_code   VARCHAR2(1) not null,
  coam_desc   VARCHAR2(30),
  coam_type   VARCHAR2(1) not null,
  coam_nature VARCHAR2(1),
  constraint ACT_SM_COA_MAIN_PK primary key (COAM_CODE)
);

-- COA Opening Balance Master
create table MDHSYS.ACT_SM_COA_OPNBAL (
  mco_cp_code   VARCHAR2(2) not null,
  mco_fyr_fm    DATE not null,
  mco_fyr_to    DATE not null,
  mco_status    VARCHAR2(1) not null,
  mco_coa3_code VARCHAR2(8),
  mco_remark    VARCHAR2(80),
  constraint ACT_SM_COA_OPNBAL_PK primary key (MCO_FYR_FM, MCO_FYR_TO, MCO_CP_CODE)
);

-- Depreciation Allocation Master
create table MDHSYS.ACT_SM_DEP_ALLOCATION (
  mca_cp_code  VARCHAR2(2) not null,
  mca_cat_id   VARCHAR2(8) not null,
  mca_eff_date DATE not null,
  mca_cst_coa3 VARCHAR2(10),
  mca_ins_user VARCHAR2(30),
  mca_ast_year NUMBER(2),
  mca_tfa_coa3 VARCHAR2(10),
  mca_dep_coa3 VARCHAR2(10),
  mca_exp_coa3 VARCHAR2(10),
  mca_rvl_coa3 VARCHAR2(10),
  mca_pnl_coa3 VARCHAR2(10),
  mca_rate     NUMBER,
  constraint ACT_SM_DEP_ALLOCATION_PK primary key (MCA_CP_CODE, MCA_CAT_ID, MCA_EFF_DATE)
);

-- Format Master
create table MDHSYS.ACT_SM_FORMAT (
  mfr_cp_code VARCHAR2(2) not null,
  mfr_code    VARCHAR2(2) not null,
  mfr_name    VARCHAR2(40),
  mfr_type    VARCHAR2(1) not null,
  constraint ACT_SM_FORMAT_PK primary key (MFR_CODE, MFR_CP_CODE)
);

-- Group COA3 Master
create table MDHSYS.ACT_SM_GRP_COA3 (
  mgp_cp_code VARCHAR2(2) not null,
  mgp_code    VARCHAR2(8) not null,
  mgp_name    VARCHAR2(200),
  mgp_active  VARCHAR2(1),
  mgp_br_code VARCHAR2(3),
  constraint ACT_SM_GRP_COA3_PK primary key (MGP_CP_CODE, MGP_CODE)
);

-- Period Budget Master
create table MDHSYS.ACT_SM_PRD_BUDGET (
  mbg_cp_code VARCHAR2(2) not null,
  mbg_date_fm DATE not null,
  mbg_date_to DATE not null,
  mbg_desc    VARCHAR2(30),
  mbg_status  VARCHAR2(1) not null,
  constraint ACT_SM_PRD_BUDGET_PK primary key (MBG_DATE_FM, MBG_DATE_TO, MBG_CP_CODE)
);

-- Voucher Master
create table MDHSYS.ACT_SM_VOUCHER (
  mdv_cp_code   VARCHAR2(2) not null,
  mdv_mdv_code  VARCHAR2(15) not null,
  mdv_mdv_date  DATE,
  mdv_mdv_desc  VARCHAR2(200),
  mdv_mdv_ref   VARCHAR2(50),
  mdv_dbt_amt   NUMBER(13,2),
  mdv_crd_amt   NUMBER(13,2),
  mdv_status    VARCHAR2(1),
  mdv_ins_user  VARCHAR2(30),
  mdv_ins_date  DATE,
  mdv_upd_user  VARCHAR2(30),
  mdv_upd_date  DATE,
  constraint ACT_SM_VOUCHER_PK primary key (MDV_MDV_CODE, MDV_CP_CODE)
);

-- ============================================
-- HOSPITAL SPECIFIC TABLES
-- ============================================

-- Department Master
create table MDHSYS.DEPT_MASTER (
  dept_code    VARCHAR2(8) primary key,
  dept_name    VARCHAR2(100) not null,
  dept_type    VARCHAR2(20),
  dept_status  VARCHAR2(1) default 'A',
  created_date DATE default sysdate,
  created_by   VARCHAR2(30)
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

-- Admission
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

-- Billing
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