-- APEX 26 Application Configuration Package
-- Hospital ERP System

CREATE OR REPLACE PACKAGE MDHSYS.APP_CONFIG AS
  -- Version
  VERSION constant VARCHAR2(10) := '26.0.1';
  ENVIRONMENT constant VARCHAR2(20) := 'PRODUCTION';
  
  -- Company Settings
  COMPANY_NAME constant VARCHAR2(100) := 'Medical & Diagnostic Hospital System';
  COMPANY_SHORT_CODE constant VARCHAR2(5) := 'MDHS';
  CURRENCY constant VARCHAR2(3) := 'PKR';
  
  -- System Parameters
  MAX_USERS constant NUMBER := 500;
  SESSION_TIMEOUT constant NUMBER := 1800; -- 30 minutes
  
  -- Function to get system parameter
  FUNCTION get_parameter(p_param_name VARCHAR2) RETURN VARCHAR2;
  
  -- Function to set system parameter
  PROCEDURE set_parameter(p_param_name VARCHAR2, p_param_value VARCHAR2);
  
  -- Function to get current user
  FUNCTION get_current_user RETURN VARCHAR2;
  
  -- Function to audit log
  PROCEDURE audit_log(p_action VARCHAR2, p_table_name VARCHAR2, p_record_id VARCHAR2, p_old_value VARCHAR2, p_new_value VARCHAR2);
  
END APP_CONFIG;
/

CREATE OR REPLACE PACKAGE BODY MDHSYS.APP_CONFIG AS
  
  FUNCTION get_parameter(p_param_name VARCHAR2) RETURN VARCHAR2 AS
    l_value VARCHAR2(4000);
  BEGIN
    SELECT param_value INTO l_value FROM MDHSYS.SYSTEM_PARAMETERS WHERE param_name = p_param_name;
    RETURN l_value;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_parameter;
  
  PROCEDURE set_parameter(p_param_name VARCHAR2, p_param_value VARCHAR2) AS
  BEGIN
    UPDATE MDHSYS.SYSTEM_PARAMETERS SET param_value = p_param_value WHERE param_name = p_param_name;
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO MDHSYS.SYSTEM_PARAMETERS (param_name, param_value, created_date) VALUES (p_param_name, p_param_value, SYSDATE);
    END IF;
    COMMIT;
  END set_parameter;
  
  FUNCTION get_current_user RETURN VARCHAR2 AS
  BEGIN
    RETURN USER;
  END get_current_user;
  
  PROCEDURE audit_log(p_action VARCHAR2, p_table_name VARCHAR2, p_record_id VARCHAR2, p_old_value VARCHAR2, p_new_value VARCHAR2) AS
  BEGIN
    INSERT INTO MDHSYS.AUDIT_LOG (action, table_name, record_id, old_value, new_value, user_name, log_date)
    VALUES (p_action, p_table_name, p_record_id, p_old_value, p_new_value, USER, SYSDATE);
    COMMIT;
  END audit_log;
  
END APP_CONFIG;
/