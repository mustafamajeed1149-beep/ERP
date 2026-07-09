-- APEX 26 Patient Management Package
-- Hospital ERP System

CREATE OR REPLACE PACKAGE MDHSYS.PATIENT_MANAGEMENT AS
  
  -- Create new patient
  FUNCTION create_patient(
    p_patient_name VARCHAR2,
    p_gender VARCHAR2,
    p_dob DATE,
    p_contact_no VARCHAR2,
    p_email VARCHAR2,
    p_address VARCHAR2,
    p_city VARCHAR2
  ) RETURN VARCHAR2;
  
  -- Update patient information
  PROCEDURE update_patient(
    p_patient_id VARCHAR2,
    p_patient_name VARCHAR2,
    p_contact_no VARCHAR2,
    p_email VARCHAR2,
    p_address VARCHAR2
  );
  
  -- Get patient details
  FUNCTION get_patient_details(p_patient_id VARCHAR2) RETURN MDHSYS.PATIENT_MASTER%ROWTYPE;
  
  -- Search patients
  FUNCTION search_patients(p_search_criteria VARCHAR2) RETURN SYS_REFCURSOR;
  
  -- Validate patient
  FUNCTION validate_patient(p_patient_id VARCHAR2) RETURN BOOLEAN;
  
END PATIENT_MANAGEMENT;
/

CREATE OR REPLACE PACKAGE BODY MDHSYS.PATIENT_MANAGEMENT AS
  
  FUNCTION create_patient(
    p_patient_name VARCHAR2,
    p_gender VARCHAR2,
    p_dob DATE,
    p_contact_no VARCHAR2,
    p_email VARCHAR2,
    p_address VARCHAR2,
    p_city VARCHAR2
  ) RETURN VARCHAR2 AS
    l_patient_id VARCHAR2(10);
  BEGIN
    l_patient_id := 'P' || LPAD(MDHSYS.PATIENT_SEQ.NEXTVAL, 9, '0');
    
    INSERT INTO MDHSYS.PATIENT_MASTER (
      patient_id, patient_name, gender, dob, contact_no, email, address, city, created_date, created_by
    ) VALUES (
      l_patient_id, p_patient_name, p_gender, p_dob, p_contact_no, p_email, p_address, p_city, SYSDATE, USER
    );
    
    COMMIT;
    RETURN l_patient_id;
  END create_patient;
  
  PROCEDURE update_patient(
    p_patient_id VARCHAR2,
    p_patient_name VARCHAR2,
    p_contact_no VARCHAR2,
    p_email VARCHAR2,
    p_address VARCHAR2
  ) AS
  BEGIN
    UPDATE MDHSYS.PATIENT_MASTER SET
      patient_name = p_patient_name,
      contact_no = p_contact_no,
      email = p_email,
      address = p_address
    WHERE patient_id = p_patient_id;
    
    COMMIT;
  END update_patient;
  
  FUNCTION get_patient_details(p_patient_id VARCHAR2) RETURN MDHSYS.PATIENT_MASTER%ROWTYPE AS
    l_patient MDHSYS.PATIENT_MASTER%ROWTYPE;
  BEGIN
    SELECT * INTO l_patient FROM MDHSYS.PATIENT_MASTER WHERE patient_id = p_patient_id;
    RETURN l_patient;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_patient_details;
  
  FUNCTION search_patients(p_search_criteria VARCHAR2) RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
  BEGIN
    OPEN l_cursor FOR
      SELECT * FROM MDHSYS.PATIENT_MASTER
      WHERE patient_name LIKE '%' || p_search_criteria || '%'
         OR contact_no LIKE '%' || p_search_criteria || '%'
         OR patient_id = p_search_criteria;
    RETURN l_cursor;
  END search_patients;
  
  FUNCTION validate_patient(p_patient_id VARCHAR2) RETURN BOOLEAN AS
    l_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_count FROM MDHSYS.PATIENT_MASTER WHERE patient_id = p_patient_id;
    RETURN l_count > 0;
  END validate_patient;
  
END PATIENT_MANAGEMENT;
/