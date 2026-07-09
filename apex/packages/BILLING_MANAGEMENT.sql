-- APEX 26 Billing Management Package
-- Hospital ERP System

CREATE OR REPLACE PACKAGE MDHSYS.BILLING_MANAGEMENT AS
  
  -- Create new bill
  FUNCTION create_bill(
    p_patient_id VARCHAR2,
    p_admission_id VARCHAR2,
    p_total_amount NUMBER
  ) RETURN VARCHAR2;
  
  -- Add bill details
  PROCEDURE add_bill_detail(
    p_bill_id VARCHAR2,
    p_service_name VARCHAR2,
    p_quantity NUMBER,
    p_unit_price NUMBER
  );
  
  -- Process payment
  PROCEDURE process_payment(
    p_bill_id VARCHAR2,
    p_paid_amount NUMBER,
    p_payment_mode VARCHAR2,
    p_reference_no VARCHAR2
  );
  
  -- Get bill details
  FUNCTION get_bill_details(p_bill_id VARCHAR2) RETURN SYS_REFCURSOR;
  
  -- Calculate total
  FUNCTION calculate_bill_total(p_bill_id VARCHAR2) RETURN NUMBER;
  
END BILLING_MANAGEMENT;
/

CREATE OR REPLACE PACKAGE BODY MDHSYS.BILLING_MANAGEMENT AS
  
  FUNCTION create_bill(
    p_patient_id VARCHAR2,
    p_admission_id VARCHAR2,
    p_total_amount NUMBER
  ) RETURN VARCHAR2 AS
    l_bill_id VARCHAR2(15);
  BEGIN
    l_bill_id := 'BILL' || LPAD(MDHSYS.BILL_SEQ.NEXTVAL, 10, '0');
    
    INSERT INTO MDHSYS.BILLING (
      bill_id, patient_id, admission_id, bill_date, total_amount, paid_amount, balance, bill_status, created_date, created_by
    ) VALUES (
      l_bill_id, p_patient_id, p_admission_id, SYSDATE, p_total_amount, 0, p_total_amount, 'OPEN', SYSDATE, USER
    );
    
    COMMIT;
    RETURN l_bill_id;
  END create_bill;
  
  PROCEDURE add_bill_detail(
    p_bill_id VARCHAR2,
    p_service_name VARCHAR2,
    p_quantity NUMBER,
    p_unit_price NUMBER
  ) AS
    l_total_amount NUMBER;
  BEGIN
    l_total_amount := p_quantity * p_unit_price;
    
    INSERT INTO MDHSYS.BILLING_DETAILS (bill_detail_id, bill_id, service_name, quantity, unit_price, total_amount)
    VALUES ('BILLDET' || LPAD(MDHSYS.BILL_SEQ.NEXTVAL, 10, '0'), p_bill_id, p_service_name, p_quantity, p_unit_price, l_total_amount);
    
    COMMIT;
  END add_bill_detail;
  
  PROCEDURE process_payment(
    p_bill_id VARCHAR2,
    p_paid_amount NUMBER,
    p_payment_mode VARCHAR2,
    p_reference_no VARCHAR2
  ) AS
  BEGIN
    UPDATE MDHSYS.BILLING SET
      paid_amount = paid_amount + p_paid_amount,
      balance = total_amount - (paid_amount + p_paid_amount),
      bill_status = CASE WHEN (paid_amount + p_paid_amount) >= total_amount THEN 'CLOSED' ELSE 'PARTIAL' END
    WHERE bill_id = p_bill_id;
    
    COMMIT;
  END process_payment;
  
  FUNCTION get_bill_details(p_bill_id VARCHAR2) RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
  BEGIN
    OPEN l_cursor FOR
      SELECT * FROM MDHSYS.BILLING_DETAILS WHERE bill_id = p_bill_id;
    RETURN l_cursor;
  END get_bill_details;
  
  FUNCTION calculate_bill_total(p_bill_id VARCHAR2) RETURN NUMBER AS
    l_total NUMBER;
  BEGIN
    SELECT COALESCE(SUM(total_amount), 0) INTO l_total FROM MDHSYS.BILLING_DETAILS WHERE bill_id = p_bill_id;
    RETURN l_total;
  END calculate_bill_total;
  
END BILLING_MANAGEMENT;
/