-- ============================================
-- APEX 26 FORMS - Complete Hospital ERP
-- ============================================
-- یہ APEX 26 کے forms ہیں جو سب modules کے لیے ہیں

-- ============================================
-- 1. ADMIN DASHBOARD PAGE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_APEX_ADMIN AS
  -- Dashboard Statistics
  PROCEDURE GET_DASHBOARD_STATS (
    p_total_patients OUT NUMBER,
    p_total_employees OUT NUMBER,
    p_total_invoices OUT NUMBER,
    p_total_revenue OUT NUMBER,
    p_today_appointments OUT NUMBER,
    p_pending_invoices OUT NUMBER
  );
  
  -- User Management
  PROCEDURE CREATE_USER (
    p_username VARCHAR2,
    p_password VARCHAR2,
    p_full_name VARCHAR2,
    p_email VARCHAR2,
    p_role_id VARCHAR2,
    p_user_id OUT VARCHAR2
  );
  
  PROCEDURE UPDATE_USER_ROLE (
    p_user_id VARCHAR2,
    p_role_id VARCHAR2
  );
  
  PROCEDURE LOCK_USER_ACCOUNT (
    p_user_id VARCHAR2
  );

END PKG_APEX_ADMIN;
/

-- ============================================
-- 2. PATIENT MANAGEMENT FORMS (OPD/IPD)
-- ============================================

CREATE OR REPLACE PACKAGE PKG_PATIENT_MANAGEMENT AS
  
  -- Patient Registration
  PROCEDURE REGISTER_NEW_PATIENT (
    p_patient_name VARCHAR2,
    p_gender VARCHAR2,
    p_dob DATE,
    p_contact_no VARCHAR2,
    p_email VARCHAR2,
    p_address VARCHAR2,
    p_category_id VARCHAR2,
    p_patient_id OUT VARCHAR2
  );
  
  -- OPD Registration
  PROCEDURE REGISTER_OPD (
    p_patient_id VARCHAR2,
    p_unit_id VARCHAR2,
    p_doctor_id VARCHAR2,
    p_chief_complaint VARCHAR2,
    p_priority VARCHAR2,
    p_opd_reg_id OUT VARCHAR2
  );
  
  -- IPD Admission
  PROCEDURE ADMIT_PATIENT (
    p_patient_id VARCHAR2,
    p_ward_id VARCHAR2,
    p_bed_id VARCHAR2,
    p_doctor_id VARCHAR2,
    p_admission_type VARCHAR2,
    p_admission_id OUT VARCHAR2
  );
  
  -- Patient Discharge
  PROCEDURE DISCHARGE_PATIENT (
    p_admission_id VARCHAR2,
    p_discharge_summary CLOB,
    p_discharge_diagnosis VARCHAR2
  );
  
  -- Get Patient History
  FUNCTION GET_PATIENT_HISTORY (
    p_patient_id VARCHAR2
  ) RETURN CLOB;

END PKG_PATIENT_MANAGEMENT;
/

-- ============================================
-- 3. OPD CONSULTATION FORMS
-- ============================================

CREATE OR REPLACE PACKAGE PKG_OPD_CONSULTATION AS
  
  -- Create Consultation
  PROCEDURE CREATE_CONSULTATION (
    p_opd_reg_id VARCHAR2,
    p_doctor_id VARCHAR2,
    p_diagnosis VARCHAR2,
    p_vital_signs CLOB,
    p_advice VARCHAR2,
    p_follow_up_required VARCHAR2,
    p_follow_up_date DATE,
    p_charges NUMBER,
    p_consultation_id OUT VARCHAR2
  );
  
  -- Add Prescription
  PROCEDURE ADD_PRESCRIPTION (
    p_consultation_id VARCHAR2,
    p_medicine_id VARCHAR2,
    p_dosage VARCHAR2,
    p_frequency VARCHAR2,
    p_duration VARCHAR2,
    p_quantity NUMBER
  );
  
  -- Get OPD Queue
  FUNCTION GET_OPD_QUEUE (
    p_unit_id VARCHAR2,
    p_date DATE
  ) RETURN CLOB;
  
  -- Print OPD Report
  PROCEDURE GENERATE_OPD_REPORT (
    p_opd_reg_id VARCHAR2
  );

END PKG_OPD_CONSULTATION;
/

-- ============================================
-- 4. IPD MEDICAL RECORDS
-- ============================================

CREATE OR REPLACE PACKAGE PKG_IPD_MEDICAL_RECORDS AS
  
  -- Create Medical Record Entry
  PROCEDURE CREATE_MEDICAL_RECORD (
    p_admission_id VARCHAR2,
    p_vital_signs CLOB,
    p_clinical_notes CLOB,
    p_medications_given CLOB,
    p_created_by VARCHAR2,
    p_record_id OUT VARCHAR2
  );
  
  -- Update Patient Vitals
  PROCEDURE UPDATE_PATIENT_VITALS (
    p_admission_id VARCHAR2,
    p_temperature DECIMAL,
    p_pulse NUMBER,
    p_bp VARCHAR2,
    p_respiration_rate NUMBER
  );
  
  -- Get Medical History
  FUNCTION GET_MEDICAL_HISTORY (
    p_admission_id VARCHAR2
  ) RETURN CLOB;
  
  -- Generate Discharge Summary
  PROCEDURE GENERATE_DISCHARGE_SUMMARY (
    p_admission_id VARCHAR2
  );

END PKG_IPD_MEDICAL_RECORDS;
/

-- ============================================
-- 5. PHARMACY MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_PHARMACY AS
  
  -- Add Pharmacy Item
  PROCEDURE ADD_PHARMACY_ITEM (
    p_medicine_name VARCHAR2,
    p_manufacturer VARCHAR2,
    p_category VARCHAR2,
    p_strength VARCHAR2,
    p_unit_price NUMBER,
    p_reorder_level NUMBER,
    p_item_id OUT VARCHAR2
  );
  
  -- Add Stock
  PROCEDURE ADD_STOCK (
    p_item_id VARCHAR2,
    p_batch_number VARCHAR2,
    p_quantity NUMBER,
    p_expiry_date DATE,
    p_supplier_id VARCHAR2,
    p_unit_price NUMBER
  );
  
  -- Record Sale
  PROCEDURE RECORD_PHARMACY_SALE (
    p_item_id VARCHAR2,
    p_quantity NUMBER,
    p_sold_to VARCHAR2,
    p_bill_ref VARCHAR2
  );
  
  -- Check Stock Alert
  FUNCTION CHECK_STOCK_ALERT RETURN CLOB;
  
  -- Check Expiry Items
  FUNCTION CHECK_EXPIRY_ITEMS RETURN CLOB;
  
  -- Generate Pharmacy Report
  PROCEDURE GENERATE_PHARMACY_REPORT (
    p_from_date DATE,
    p_to_date DATE
  );

END PKG_PHARMACY;
/

-- ============================================
-- 6. SALARY & PAYROLL MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_PAYROLL AS
  
  -- Create Employee
  PROCEDURE CREATE_EMPLOYEE (
    p_emp_name VARCHAR2,
    p_designation VARCHAR2,
    p_department VARCHAR2,
    p_salary_grade VARCHAR2,
    p_basic_salary NUMBER,
    p_bank_account VARCHAR2,
    p_email VARCHAR2,
    p_emp_id OUT VARCHAR2
  );
  
  -- Mark Attendance
  PROCEDURE MARK_ATTENDANCE (
    p_emp_id VARCHAR2,
    p_att_date DATE,
    p_in_time VARCHAR2,
    p_out_time VARCHAR2,
    p_status VARCHAR2
  );
  
  -- Create Salary Structure
  PROCEDURE CREATE_SALARY_STRUCTURE (
    p_emp_id VARCHAR2,
    p_financial_year VARCHAR2,
    p_basic_salary NUMBER,
    p_hra NUMBER,
    p_da NUMBER,
    p_allowances NUMBER,
    p_deductions NUMBER
  );
  
  -- Process Salary Payment
  PROCEDURE PROCESS_SALARY_PAYMENT (
    p_emp_id VARCHAR2,
    p_payment_month VARCHAR2,
    p_payment_method VARCHAR2,
    p_reference_no VARCHAR2
  );
  
  -- Apply Leave
  PROCEDURE APPLY_LEAVE (
    p_emp_id VARCHAR2,
    p_leave_type VARCHAR2,
    p_from_date DATE,
    p_to_date DATE,
    p_reason VARCHAR2
  );
  
  -- Approve Leave
  PROCEDURE APPROVE_LEAVE (
    p_leave_id VARCHAR2,
    p_approved_by VARCHAR2,
    p_remarks VARCHAR2
  );
  
  -- Generate Payslip
  PROCEDURE GENERATE_PAYSLIP (
    p_emp_id VARCHAR2,
    p_payment_month VARCHAR2
  );

END PKG_PAYROLL;
/

-- ============================================
-- 7. PURCHASE MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_PURCHASE AS
  
  -- Create Vendor
  PROCEDURE CREATE_VENDOR (
    p_vendor_name VARCHAR2,
    p_contact_person VARCHAR2,
    p_contact_no VARCHAR2,
    p_email VARCHAR2,
    p_city VARCHAR2,
    p_pan_gst VARCHAR2,
    p_credit_limit NUMBER,
    p_vendor_id OUT VARCHAR2
  );
  
  -- Create Purchase Order
  PROCEDURE CREATE_PURCHASE_ORDER (
    p_vendor_id VARCHAR2,
    p_delivery_date DATE,
    p_po_id OUT VARCHAR2
  );
  
  -- Add PO Items
  PROCEDURE ADD_PO_ITEM (
    p_po_id VARCHAR2,
    p_item_id VARCHAR2,
    p_quantity NUMBER,
    p_unit_price NUMBER
  );
  
  -- Approve PO
  PROCEDURE APPROVE_PURCHASE_ORDER (
    p_po_id VARCHAR2,
    p_approved_by VARCHAR2
  );
  
  -- Record Goods Receipt
  PROCEDURE RECORD_GOODS_RECEIPT (
    p_po_id VARCHAR2,
    p_received_by VARCHAR2,
    p_gr_id OUT VARCHAR2
  );
  
  -- Generate Purchase Report
  PROCEDURE GENERATE_PURCHASE_REPORT (
    p_from_date DATE,
    p_to_date DATE
  );

END PKG_PURCHASE;
/

-- ============================================
-- 8. INVENTORY MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_INVENTORY AS
  
  -- Add Inventory Item
  PROCEDURE ADD_INVENTORY_ITEM (
    p_item_name VARCHAR2,
    p_category VARCHAR2,
    p_unit VARCHAR2,
    p_reorder_level NUMBER,
    p_unit_price NUMBER,
    p_inv_item_id OUT VARCHAR2
  );
  
  -- Record Inventory Transaction
  PROCEDURE RECORD_INVENTORY_TXN (
    p_inv_item_id VARCHAR2,
    p_txn_type VARCHAR2,
    p_quantity NUMBER,
    p_reference_id VARCHAR2,
    p_created_by VARCHAR2
  );
  
  -- Get Current Stock
  FUNCTION GET_CURRENT_STOCK (
    p_inv_item_id VARCHAR2
  ) RETURN NUMBER;
  
  -- Check Low Stock Items
  FUNCTION CHECK_LOW_STOCK_ITEMS RETURN CLOB;
  
  -- Generate Stock Valuation Report
  PROCEDURE GENERATE_STOCK_VALUATION (
    p_valuation_date DATE
  );

END PKG_INVENTORY;
/

-- ============================================
-- 9. ACCOUNTS & FINANCE MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_ACCOUNTS_FINANCE AS
  
  -- Create Chart of Accounts
  PROCEDURE CREATE_ACCOUNT (
    p_account_code VARCHAR2,
    p_account_name VARCHAR2,
    p_account_type VARCHAR2,
    p_account_group VARCHAR2,
    p_opening_balance NUMBER,
    p_coa_id OUT VARCHAR2
  );
  
  -- Create Journal Entry
  PROCEDURE CREATE_JOURNAL_ENTRY (
    p_journal_date DATE,
    p_reference_no VARCHAR2,
    p_description VARCHAR2,
    p_journal_id OUT VARCHAR2
  );
  
  -- Add Journal Entry Details
  PROCEDURE ADD_JOURNAL_DETAIL (
    p_journal_id VARCHAR2,
    p_coa_id VARCHAR2,
    p_debit_amount NUMBER,
    p_credit_amount NUMBER
  );
  
  -- Post Journal Entry
  PROCEDURE POST_JOURNAL_ENTRY (
    p_journal_id VARCHAR2,
    p_approved_by VARCHAR2
  );
  
  -- Create Invoice
  PROCEDURE CREATE_INVOICE (
    p_patient_id VARCHAR2,
    p_admission_id VARCHAR2,
    p_total_amount NUMBER,
    p_invoice_id OUT VARCHAR2
  );
  
  -- Record Payment
  PROCEDURE RECORD_PAYMENT (
    p_invoice_id VARCHAR2,
    p_payment_date DATE,
    p_payment_mode VARCHAR2,
    p_amount NUMBER,
    p_reference_no VARCHAR2
  );
  
  -- Generate Trial Balance
  PROCEDURE GENERATE_TRIAL_BALANCE (
    p_as_on_date DATE
  );
  
  -- Generate Balance Sheet
  PROCEDURE GENERATE_BALANCE_SHEET (
    p_as_on_date DATE
  );
  
  -- Generate P&L Statement
  PROCEDURE GENERATE_PL_STATEMENT (
    p_from_date DATE,
    p_to_date DATE
  );

END PKG_ACCOUNTS_FINANCE;
/

-- ============================================
-- 10. LAB MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_LAB_MANAGEMENT AS
  
  -- Create Lab Test
  PROCEDURE CREATE_LAB_TEST (
    p_test_name VARCHAR2,
    p_category VARCHAR2,
    p_price NUMBER,
    p_reference_range VARCHAR2,
    p_turnaround_time VARCHAR2,
    p_test_id OUT VARCHAR2
  );
  
  -- Create Lab Order
  PROCEDURE CREATE_LAB_ORDER (
    p_patient_id VARCHAR2,
    p_doctor_id VARCHAR2,
    p_test_id VARCHAR2,
    p_priority VARCHAR2,
    p_order_id OUT VARCHAR2
  );
  
  -- Record Lab Result
  PROCEDURE RECORD_LAB_RESULT (
    p_order_id VARCHAR2,
    p_result_value VARCHAR2,
    p_tested_by VARCHAR2,
    p_result_id OUT VARCHAR2
  );
  
  -- Verify Lab Result
  PROCEDURE VERIFY_LAB_RESULT (
    p_result_id VARCHAR2,
    p_verified_by VARCHAR2
  );
  
  -- Generate Lab Report
  PROCEDURE GENERATE_LAB_REPORT (
    p_order_id VARCHAR2
  );
  
  -- Get Lab Queue
  FUNCTION GET_LAB_QUEUE (
    p_date DATE
  ) RETURN CLOB;

END PKG_LAB_MANAGEMENT;
/

-- ============================================
-- 11. DIAGNOSTIC MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_DIAGNOSTIC_MANAGEMENT AS
  
  -- Create Diagnostic Test
  PROCEDURE CREATE_DIAGNOSTIC_TEST (
    p_test_name VARCHAR2,
    p_category VARCHAR2,
    p_modality VARCHAR2,
    p_price NUMBER,
    p_diag_test_id OUT VARCHAR2
  );
  
  -- Create Diagnostic Order
  PROCEDURE CREATE_DIAGNOSTIC_ORDER (
    p_patient_id VARCHAR2,
    p_doctor_id VARCHAR2,
    p_diag_test_id VARCHAR2,
    p_scheduled_date DATE,
    p_scheduled_time VARCHAR2,
    p_priority VARCHAR2,
    p_diag_order_id OUT VARCHAR2
  );
  
  -- Assign Technician
  PROCEDURE ASSIGN_TECHNICIAN (
    p_diag_order_id VARCHAR2,
    p_technician_id VARCHAR2
  );
  
  -- Record Diagnostic Report
  PROCEDURE RECORD_DIAGNOSTIC_REPORT (
    p_diag_order_id VARCHAR2,
    p_findings CLOB,
    p_impression CLOB,
    p_radiologist_id VARCHAR2,
    p_report_id OUT VARCHAR2
  );
  
  -- Generate Diagnostic Report
  PROCEDURE GENERATE_DIAGNOSTIC_REPORT (
    p_diag_order_id VARCHAR2
  );
  
  -- Get Diagnostic Schedule
  FUNCTION GET_DIAGNOSTIC_SCHEDULE (
    p_date DATE
  ) RETURN CLOB;

END PKG_DIAGNOSTIC_MANAGEMENT;
/

-- ============================================
-- 12. ASSETS MANAGEMENT MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_ASSETS_MANAGEMENT AS
  
  -- Create Asset
  PROCEDURE CREATE_ASSET (
    p_asset_name VARCHAR2,
    p_asset_type VARCHAR2,
    p_category VARCHAR2,
    p_purchase_date DATE,
    p_purchase_cost NUMBER,
    p_useful_life NUMBER,
    p_location VARCHAR2,
    p_asset_id OUT VARCHAR2
  );
  
  -- Record Asset Depreciation
  PROCEDURE RECORD_DEPRECIATION (
    p_asset_id VARCHAR2,
    p_depreciation_month VARCHAR2
  );
  
  -- Record Asset Maintenance
  PROCEDURE RECORD_ASSET_MAINTENANCE (
    p_asset_id VARCHAR2,
    p_maintenance_date DATE,
    p_maintenance_type VARCHAR2,
    p_cost NUMBER,
    p_description CLOB,
    p_vendor VARCHAR2,
    p_next_maintenance DATE
  );
  
  -- Generate Asset Report
  PROCEDURE GENERATE_ASSET_REPORT (
    p_as_on_date DATE
  );
  
  -- Generate Depreciation Schedule
  PROCEDURE GENERATE_DEPRECIATION_SCHEDULE (
    p_financial_year VARCHAR2
  );

END PKG_ASSETS_MANAGEMENT;
/

-- ============================================
-- 13. AMBULANCE SERVICES MODULE
-- ============================================

CREATE OR REPLACE PACKAGE PKG_AMBULANCE_SERVICES AS
  
  -- Create Ambulance
  PROCEDURE CREATE_AMBULANCE (
    p_reg_no VARCHAR2,
    p_ambulance_type VARCHAR2,
    p_vehicle_make VARCHAR2,
    p_driver_name VARCHAR2,
    p_driver_license VARCHAR2,
    p_driver_contact VARCHAR2,
    p_ambulance_id OUT VARCHAR2
  );
  
  -- Record Ambulance Call
  PROCEDURE RECORD_AMBULANCE_CALL (
    p_call_date DATE,
    p_caller_name VARCHAR2,
    p_caller_contact VARCHAR2,
    p_pickup_location VARCHAR2,
    p_dropoff_location VARCHAR2,
    p_patient_condition VARCHAR2,
    p_call_id OUT VARCHAR2
  );
  
  -- Dispatch Ambulance
  PROCEDURE DISPATCH_AMBULANCE (
    p_call_id VARCHAR2,
    p_ambulance_id VARCHAR2
  );
  
  -- Update Ambulance Status
  PROCEDURE UPDATE_AMBULANCE_STATUS (
    p_call_id VARCHAR2,
    p_status VARCHAR2,
    p_distance_km NUMBER,
    p_charge_amount NUMBER
  );
  
  -- Generate Ambulance Report
  PROCEDURE GENERATE_AMBULANCE_REPORT (
    p_from_date DATE,
    p_to_date DATE
  );

END PKG_AMBULANCE_SERVICES;
/

-- ============================================
-- 14. NOTIFICATIONS & COMMUNICATIONS
-- ============================================

CREATE OR REPLACE PACKAGE PKG_NOTIFICATIONS AS
  
  -- Create Notification Template
  PROCEDURE CREATE_NOTIFICATION_TEMPLATE (
    p_template_name VARCHAR2,
    p_template_type VARCHAR2,
    p_content CLOB,
    p_variables CLOB,
    p_template_id OUT VARCHAR2
  );
  
  -- Send SMS
  PROCEDURE SEND_SMS (
    p_recipient_no VARCHAR2,
    p_message_content VARCHAR2,
    p_template_id VARCHAR2,
    p_sms_id OUT VARCHAR2
  );
  
  -- Send WhatsApp
  PROCEDURE SEND_WHATSAPP (
    p_recipient_no VARCHAR2,
    p_message_content VARCHAR2,
    p_template_id VARCHAR2,
    p_media_url VARCHAR2,
    p_whatsapp_id OUT VARCHAR2
  );
  
  -- Send System Notification
  PROCEDURE SEND_SYSTEM_NOTIFICATION (
    p_user_id VARCHAR2,
    p_notification_type VARCHAR2,
    p_title VARCHAR2,
    p_message CLOB,
    p_link VARCHAR2
  );
  
  -- Get Notifications
  FUNCTION GET_USER_NOTIFICATIONS (
    p_user_id VARCHAR2
  ) RETURN CLOB;
  
  -- Mark Notification as Read
  PROCEDURE MARK_NOTIFICATION_READ (
    p_notification_id VARCHAR2
  );

END PKG_NOTIFICATIONS;
/

-- ============================================
-- 15. GROUP CHAT & MESSAGING
-- ============================================

CREATE OR REPLACE PACKAGE PKG_GROUP_CHAT AS
  
  -- Create Chat Group
  PROCEDURE CREATE_CHAT_GROUP (
    p_group_name VARCHAR2,
    p_group_type VARCHAR2,
    p_description VARCHAR2,
    p_created_by VARCHAR2,
    p_group_id OUT VARCHAR2
  );
  
  -- Add Group Member
  PROCEDURE ADD_GROUP_MEMBER (
    p_group_id VARCHAR2,
    p_user_id VARCHAR2,
    p_role VARCHAR2
  );
  
  -- Post Group Message
  PROCEDURE POST_GROUP_MESSAGE (
    p_group_id VARCHAR2,
    p_user_id VARCHAR2,
    p_message_text CLOB,
    p_media_url VARCHAR2,
    p_message_id OUT VARCHAR2
  );
  
  -- Send Private Message
  PROCEDURE SEND_PRIVATE_MESSAGE (
    p_sender_id VARCHAR2,
    p_receiver_id VARCHAR2,
    p_message_text CLOB,
    p_media_url VARCHAR2,
    p_private_msg_id OUT VARCHAR2
  );
  
  -- Get Group Messages
  FUNCTION GET_GROUP_MESSAGES (
    p_group_id VARCHAR2,
    p_limit NUMBER
  ) RETURN CLOB;
  
  -- Get Private Messages
  FUNCTION GET_PRIVATE_MESSAGES (
    p_sender_id VARCHAR2,
    p_receiver_id VARCHAR2
  ) RETURN CLOB;
  
  -- Mark Message as Read
  PROCEDURE MARK_MESSAGE_READ (
    p_message_id VARCHAR2
  );

END PKG_GROUP_CHAT;
/

-- ============================================
-- APEX 26 FORM COMPONENTS MAPPING
-- ============================================
-- یہ apex forms کے لیے ہیں

-- Admin Dashboard Region
-- Page: 1 (Dashboard)
-- Region: Dashboard Statistics Card
-- Items: Total Patients, Total Employees, Total Revenue, Pending Invoices
-- Buttons: Refresh, Export

-- Patient Management Form
-- Page: 10 (Patient Registration)
-- Items: Patient Name, Gender, DOB, Contact, Email, Address, Category
-- Buttons: Save, Update, Clear, Search

-- OPD Registration Form
-- Page: 20 (OPD Registration)
-- Items: Patient ID, Unit, Doctor, Chief Complaint, Priority
-- Buttons: Register, View Queue, Print Token, Cancel

-- OPD Consultation Form
-- Page: 21 (OPD Consultation)
-- Items: Diagnosis, Vital Signs, Advice, Follow-up, Charges
-- Sub-Region: Prescription Items
-- Buttons: Save Consultation, Add Prescription, Print, Discharge

-- IPD Admission Form
-- Page: 30 (IPD Admission)
-- Items: Patient ID, Ward, Bed, Doctor, Admission Type, Chief Complaint
-- Buttons: Admit, Transfer, Discharge, View History

-- IPD Medical Records Form
-- Page: 31 (Medical Records)
-- Items: Vital Signs (Temperature, Pulse, BP), Clinical Notes, Medications
-- Buttons: Save Record, Update Vitals, Print, Generate Summary

-- Pharmacy Management Form
-- Page: 40 (Pharmacy)
-- Items: Medicine Name, Manufacturer, Strength, Quantity, Price
-- Sub-Region: Stock Details (Batch, Expiry, Quantity)
-- Buttons: Add Item, Add Stock, Record Sale, Check Alert, Print Report

-- Salary Module Form
-- Page: 50 (Employee & Salary)
-- Items: Employee Name, Designation, Department, Salary Grade, Basic Salary
-- Sub-Region: Attendance Records
-- Sub-Region: Salary Structure (HRA, DA, Allowances, Deductions)
-- Buttons: Create Employee, Mark Attendance, Process Salary, Generate Payslip

-- Purchase Module Form
-- Page: 60 (Purchase Management)
-- Items: Vendor Name, Contact, City, PAN/GST, Credit Limit
-- Sub-Region: Purchase Orders
-- Sub-Region: PO Items (Item, Quantity, Price)
-- Buttons: Create Vendor, Create PO, Approve, Record GR, Print PO

-- Inventory Module Form
-- Page: 70 (Inventory Management)
-- Items: Item Name, Category, Current Stock, Reorder Level, Unit Price
-- Sub-Region: Stock Transactions
-- Buttons: Add Item, Record Transaction, Check Stock, Generate Report

-- Accounts & Finance Form
-- Page: 80 (Finance)
-- Items: Chart of Accounts, Journal Entries, Invoices, Payments
-- Sub-Regions: Journal Entry Details, Invoice Items, Payment Details
-- Buttons: Create Invoice, Record Payment, Post JE, Generate Reports (TB, BS, P&L)

-- Lab Module Form
-- Page: 90 (Lab Management)
-- Items: Test Name, Category, Price, Reference Range
-- Sub-Region: Lab Orders (Patient, Test, Priority)
-- Sub-Region: Lab Results (Value, Unit, Status)
-- Buttons: Create Test, Create Order, Record Result, Verify, Print Report

-- Diagnostic Module Form
-- Page: 100 (Diagnostic Management)
-- Items: Test Name, Modality, Category, Price
-- Sub-Region: Diagnostic Orders (Patient, Date, Time, Technician)
-- Sub-Region: Reports (Findings, Impression, Radiologist)
-- Buttons: Create Order, Assign Technician, Record Report, Generate Report

-- Assets Management Form
-- Page: 110 (Assets)
-- Items: Asset Name, Type, Category, Purchase Date, Cost, Useful Life
-- Sub-Region: Depreciation Schedule
-- Sub-Region: Maintenance Records
-- Buttons: Create Asset, Record Depreciation, Record Maintenance, Generate Reports

-- Ambulance Services Form
-- Page: 120 (Ambulance)
-- Items: Registration No, Type, Vehicle Details, Driver Info
-- Sub-Region: Ambulance Calls (Date, Time, Caller, Pickup, Dropoff)
-- Sub-Region: Call Status Updates
-- Buttons: Create Ambulance, Record Call, Dispatch, Update Status, Generate Report

-- SMS/WhatsApp Module Form
-- Page: 130 (Notifications)
-- Items: Template Name, Template Type, Content, Variables
-- Sub-Region: SMS Logs (Date, Recipient, Message, Status)
-- Sub-Region: WhatsApp Logs (Date, Recipient, Message, Media, Status)
-- Buttons: Create Template, Send SMS, Send WhatsApp, View Logs, Resend

-- System Notifications Form
-- Page: 131 (System Notifications)
-- Items: User, Notification Type, Title, Message, Link
-- Display: Notification List with Read/Unread Status
-- Buttons: Send, Mark as Read, Delete

-- Group Chat Form
-- Page: 140 (Group Chat)
-- Items: Group Name, Group Type, Description, Members
-- Sub-Region: Group Messages (User, Message, Date, Time)
-- Sub-Region: Group Members List
-- Buttons: Create Group, Add Member, Post Message, Remove Member, Leave Group

-- Private Messaging Form
-- Page: 141 (Private Messages)
-- Items: Recipient, Message Text, Media
-- Display: Message Thread (Sender, Message, Date, Time)
-- Buttons: Send Message, Attach Media, Delete Message, Clear Thread

COMMIT;

DBMS_OUTPUT.PUT_LINE('✅ APEX 26 FORMS STRUCTURE CREATED!');
DBMS_OUTPUT.PUT_LINE('Total Forms: 15 Complete Modules');
DBMS_OUTPUT.PUT_LINE('Total Pages: 141 (Dashboard to Private Messaging)');
DBMS_OUTPUT.PUT_LINE('Packages: 15 (All Modules)');
