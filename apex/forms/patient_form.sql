-- ============================================
-- APEX 26 - Patient Master Form (Professional)
-- Latest UI/UX with Modern Design
-- ============================================

BEGIN
    -- Delete existing objects if they exist
    BEGIN
        APEX_UTIL.REMOVE_PAGE(p_application_id => 100, p_page_id => 1);
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
END;
/

-- Create Application
DECLARE
    l_app_id NUMBER;
BEGIN
    -- Create new APEX Application
    l_app_id := APEX_APPLICATION_INSTALL.GENERATE_APPLICATION_ID;
    
    INSERT INTO apex_applications (
        APPLICATION_ID, APPLICATION_NAME, APPLICATION_ALIAS, 
        OWNER, LAST_UPDATED_BY, LAST_UPDATED_ON, APPLICATION_GROUP,
        THEME_ID, AUTHENTICATION_SCHEME, AUTHORIZATION_SCHEME
    ) VALUES (
        100, 'Hospital ERP System', 'HOSPITAL_ERP', 
        'MDHSYS', 'ADMIN', SYSDATE, 'PRODUCTION',
        42, 'NATIVE_DB_ACCOUNTS', 'UNRESTRICTED'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Application 100 created successfully');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- ============================================
-- Page 1: Dashboard
-- ============================================
BEGIN
    APEX_PAGE.CREATE_PAGE(
        p_flow_id => 100,
        p_page_id => 1,
        p_page_name => 'Dashboard',
        p_page_title => 'Hospital ERP - Dashboard',
        p_page_mode => 'NORMAL',
        p_page_template_id => 1
    );
    
    -- Add Page Title
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 1,
        p_region_name => 'Page Title',
        p_region_template_id => 1,
        p_region_type => 'STATIC_CONTENT',
        p_region_source => '<h1 style="font-size: 32px; font-weight: 700; color: #1F2937;">
                            <i class="fa fa-hospital-o"></i> Hospital ERP System
                            </h1>
                            <p style="color: #6B7280; margin-top: 8px;">Welcome to your hospital management dashboard</p>'
    );
    
    -- Statistics Cards Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 1,
        p_region_name => 'Quick Statistics',
        p_region_template_id => 1,
        p_display_sequence => 10,
        p_region_type => 'STATIC_CONTENT',
        p_region_source => '
        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-top: 30px;">
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                        padding: 25px; border-radius: 12px; color: white; box-shadow: 0 10px 25px rgba(0,0,0,0.1);">
                <div style="font-size: 14px; opacity: 0.9;">Total Patients</div>
                <div style="font-size: 32px; font-weight: 700; margin-top: 10px;">2,847</div>
                <div style="font-size: 12px; margin-top: 10px; opacity: 0.8;">↑ 12% from last month</div>
            </div>
            <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); 
                        padding: 25px; border-radius: 12px; color: white; box-shadow: 0 10px 25px rgba(0,0,0,0.1);">
                <div style="font-size: 14px; opacity: 0.9;">Active Admissions</div>
                <div style="font-size: 32px; font-weight: 700; margin-top: 10px;">156</div>
                <div style="font-size: 12px; margin-top: 10px; opacity: 0.8;">In hospital now</div>
            </div>
            <div style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); 
                        padding: 25px; border-radius: 12px; color: white; box-shadow: 0 10px 25px rgba(0,0,0,0.1);">
                <div style="font-size: 14px; opacity: 0.9;">Today Revenue</div>
                <div style="font-size: 32px; font-weight: 700; margin-top: 10px;">Rs. 5.2M</div>
                <div style="font-size: 12px; margin-top: 10px; opacity: 0.8;">↑ 8% daily</div>
            </div>
            <div style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); 
                        padding: 25px; border-radius: 12px; color: white; box-shadow: 0 10px 25px rgba(0,0,0,0.1);">
                <div style="font-size: 14px; opacity: 0.9;">Pending Bills</div>
                <div style="font-size: 32px; font-weight: 700; margin-top: 10px;">Rs. 1.8M</div>
                <div style="font-size: 12px; margin-top: 10px; opacity: 0.8;">85 invoices</div>
            </div>
        </div>'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dashboard Page created');
END;
/

-- ============================================
-- Page 2: Patient Master Form
-- ============================================
BEGIN
    APEX_PAGE.CREATE_PAGE(
        p_flow_id => 100,
        p_page_id => 2,
        p_page_name => 'Patient Master',
        p_page_title => 'Patient Master - Add/Edit',
        p_page_mode => 'NORMAL',
        p_page_template_id => 1
    );
    
    -- Form Container Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 2,
        p_region_name => 'Patient Form Container',
        p_region_template_id => 1,
        p_display_sequence => 1,
        p_region_type => 'FORM',
        p_region_source => 'MDHSYS.PATIENT_MASTER'
    );
    
    -- Form Items with Modern Styling
    DECLARE
        l_region_id NUMBER;
    BEGIN
        -- Get form region ID
        SELECT region_id INTO l_region_id 
        FROM apex_application_page_regions 
        WHERE application_id = 100 AND page_id = 2 AND region_name = 'Patient Form Container';
        
        -- Patient ID (Display Only)
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_PATIENT_ID',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Patient ID',
            p_region_id => l_region_id,
            p_display_sequence => 10,
            p_item_default_type => 'EXPRESSION',
            p_item_default => '''PATIENT_'' || TO_CHAR(SYSDATE, ''DDMMYYYY'') || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(PATIENT_ID, -4))), 0) + 1, 4, ''0'')',
            p_read_only => 'Y',
            p_display_as => 'TEXT',
            p_source_type => 'DB_COLUMN',
            p_source => 'PATIENT_ID',
            p_help_text => 'Auto-generated Patient ID'
        );
        
        -- Patient Name
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_PATIENT_NAME',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Patient Name',
            p_region_id => l_region_id,
            p_display_sequence => 20,
            p_item_width => 50,
            p_source_type => 'DB_COLUMN',
            p_source => 'PATIENT_NAME',
            p_is_required => 'Y',
            p_placeholder => 'Enter full patient name',
            p_help_text => 'First name, Middle name, Last name'
        );
        
        -- Gender
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_GENDER',
            p_item_type => 'SELECT_LIST',
            p_item_label => 'Gender',
            p_region_id => l_region_id,
            p_display_sequence => 30,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'GENDER',
            p_is_required => 'Y',
            p_display_as => 'NATIVE_SELECT_LIST'
        );
        
        -- Add Gender List Values
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_GENDER',
            p_entry_value => 'M',
            p_entry_display => 'Male'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_GENDER',
            p_entry_value => 'F',
            p_entry_display => 'Female'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_GENDER',
            p_entry_value => 'O',
            p_entry_display => 'Other'
        );
        
        -- Date of Birth
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_DOB',
            p_item_type => 'DATE_PICKER',
            p_item_label => 'Date of Birth',
            p_region_id => l_region_id,
            p_display_sequence => 40,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'DOB',
            p_date_format => 'DD-MON-YYYY',
            p_placeholder => 'DD-MON-YYYY'
        );
        
        -- Contact Number
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_CONTACT_NO',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Contact Number',
            p_region_id => l_region_id,
            p_display_sequence => 50,
            p_item_width => 30,
            p_source_type => 'DB_COLUMN',
            p_source => 'CONTACT_NO',
            p_is_required => 'Y',
            p_placeholder => '+92-300-1234567',
            p_help_text => 'Mobile or landline number'
        );
        
        -- Email
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_EMAIL',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Email Address',
            p_region_id => l_region_id,
            p_display_sequence => 60,
            p_item_width => 50,
            p_source_type => 'DB_COLUMN',
            p_source => 'EMAIL',
            p_placeholder => 'patient@email.com',
            p_help_text => 'Valid email address'
        );
        
        -- Address
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_ADDRESS',
            p_item_type => 'TEXTAREA',
            p_item_label => 'Address',
            p_region_id => l_region_id,
            p_display_sequence => 70,
            p_item_width => 100,
            p_source_type => 'DB_COLUMN',
            p_source => 'ADDRESS',
            p_placeholder => 'Enter complete address',
            p_rows => 3
        );
        
        -- City
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_CITY',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'City',
            p_region_id => l_region_id,
            p_display_sequence => 80,
            p_item_width => 30,
            p_source_type => 'DB_COLUMN',
            p_source => 'CITY',
            p_placeholder => 'Enter city name'
        );
        
        -- Status
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_PATIENT_STATUS',
            p_item_type => 'SELECT_LIST',
            p_item_label => 'Status',
            p_region_id => l_region_id,
            p_display_sequence => 90,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'PATIENT_STATUS',
            p_item_default_type => 'STATIC',
            p_item_default => 'A',
            p_display_as => 'NATIVE_SELECT_LIST'
        );
        
        -- Add Status Values
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_PATIENT_STATUS',
            p_entry_value => 'A',
            p_entry_display => 'Active'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 2,
            p_item_name => 'P2_PATIENT_STATUS',
            p_entry_value => 'I',
            p_entry_display => 'Inactive'
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Patient Form Items created');
    END;
    
    -- Add Buttons Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 2,
        p_region_name => 'Form Buttons',
        p_region_template_id => 1,
        p_display_sequence => 100,
        p_region_type => 'STATIC_CONTENT',
        p_region_source => '
        <style>
            .button-group {
                display: flex;
                gap: 12px;
                margin-top: 30px;
                justify-content: center;
            }
            .btn {
                padding: 12px 32px;
                font-size: 14px;
                font-weight: 600;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 16px rgba(102, 126, 234, 0.4);
            }
            .btn-secondary {
                background: #E5E7EB;
                color: #1F2937;
            }
            .btn-secondary:hover {
                background: #D1D5DB;
            }
            .btn-danger {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                color: white;
            }
            .btn-danger:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 16px rgba(245, 87, 108, 0.4);
            }
        </style>
        <div class="button-group">
            <button class="btn btn-primary" onclick="document.getElementById(''P2_SAVE'').click();">
                <i class="fa fa-save"></i> Save Patient
            </button>
            <button class="btn btn-secondary" onclick="window.history.back();">
                <i class="fa fa-times"></i> Cancel
            </button>
        </div>'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Patient Form Page created');
END;
/

-- ============================================
-- Page 3: Patient List (Interactive Grid)
-- ============================================
BEGIN
    APEX_PAGE.CREATE_PAGE(
        p_flow_id => 100,
        p_page_id => 3,
        p_page_name => 'Patient List',
        p_page_title => 'Patient Directory',
        p_page_mode => 'NORMAL',
        p_page_template_id => 1
    );
    
    -- Search Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 3,
        p_region_name => 'Search Bar',
        p_region_template_id => 1,
        p_display_sequence => 1,
        p_region_type => 'STATIC_CONTENT',
        p_region_source => '
        <style>
            .search-container {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 30px;
                border-radius: 12px;
                margin-bottom: 30px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            }
            .search-title {
                color: white;
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 20px;
            }
            .search-grid {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr auto;
                gap: 12px;
            }
            .search-input {
                padding: 12px 16px;
                border: 2px solid transparent;
                border-radius: 8px;
                font-size: 14px;
            }
            .search-input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }
            .btn-search {
                padding: 12px 24px;
                background: white;
                color: #667eea;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-search:hover {
                background: #f3f4f6;
            }
        </style>
        <div class="search-container">
            <div class="search-title">
                <i class="fa fa-search"></i> Find Patient
            </div>
            <div class="search-grid">
                <input type="text" class="search-input" placeholder="Search by name...">
                <input type="text" class="search-input" placeholder="Contact number...">
                <input type="text" class="search-input" placeholder="Patient ID...">
                <button class="btn-search">Search</button>
            </div>
        </div>'
    );
    
    -- Interactive Grid Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 3,
        p_region_name => 'Patient Grid',
        p_region_template_id => 1,
        p_display_sequence => 10,
        p_region_type => 'INTERACTIVE_GRID',
        p_region_source => 'SELECT PATIENT_ID, PATIENT_NAME, GENDER, DOB, CONTACT_NO, EMAIL, CITY, PATIENT_STATUS 
                            FROM MDHSYS.PATIENT_MASTER 
                            ORDER BY CREATED_DATE DESC'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Patient List Page created');
END;
/

-- ============================================
-- Page 4: Admission Form
-- ============================================
BEGIN
    APEX_PAGE.CREATE_PAGE(
        p_flow_id => 100,
        p_page_id => 4,
        p_page_name => 'Admission Entry',
        p_page_title => 'Patient Admission - Add/Edit',
        p_page_mode => 'NORMAL',
        p_page_template_id => 1
    );
    
    -- Admission Form Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 4,
        p_region_name => 'Admission Form Container',
        p_region_template_id => 1,
        p_display_sequence => 1,
        p_region_type => 'FORM',
        p_region_source => 'MDHSYS.ADMISSION'
    );
    
    DECLARE
        l_region_id NUMBER;
    BEGIN
        SELECT region_id INTO l_region_id 
        FROM apex_application_page_regions 
        WHERE application_id = 100 AND page_id = 4 AND region_name = 'Admission Form Container';
        
        -- Admission ID
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_ADMISSION_ID',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Admission ID',
            p_region_id => l_region_id,
            p_display_sequence => 10,
            p_read_only => 'Y',
            p_source_type => 'DB_COLUMN',
            p_source => 'ADMISSION_ID',
            p_item_default_type => 'EXPRESSION',
            p_item_default => '''ADM_'' || TO_CHAR(SYSDATE, ''DDMMYYYY'') || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(ADMISSION_ID, -4))), 0) + 1, 4, ''0'')'
        );
        
        -- Patient ID (LOV)
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_PATIENT_ID',
            p_item_type => 'TEXT_FIELD_WITH_LOV',
            p_item_label => 'Patient',
            p_region_id => l_region_id,
            p_display_sequence => 20,
            p_item_width => 50,
            p_source_type => 'DB_COLUMN',
            p_source => 'PATIENT_ID',
            p_is_required => 'Y',
            p_lov_query => 'SELECT PATIENT_ID || '' - '' || PATIENT_NAME display_value, PATIENT_ID return_value 
                            FROM MDHSYS.PATIENT_MASTER 
                            WHERE PATIENT_STATUS = ''A''
                            ORDER BY PATIENT_NAME'
        );
        
        -- Department (LOV)
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_DEPT_CODE',
            p_item_type => 'SELECT_LIST',
            p_item_label => 'Department',
            p_region_id => l_region_id,
            p_display_sequence => 30,
            p_item_width => 50,
            p_source_type => 'DB_COLUMN',
            p_source => 'DEPT_CODE',
            p_is_required => 'Y',
            p_lov_query => 'SELECT DEPT_NAME, DEPT_CODE FROM MDHSYS.DEPT_MASTER WHERE DEPT_STATUS = ''A'' ORDER BY DEPT_NAME'
        );
        
        -- Bed Number
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_BED_NO',
            p_item_type => 'SELECT_LIST',
            p_item_label => 'Bed Number',
            p_region_id => l_region_id,
            p_display_sequence => 40,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'BED_NO',
            p_is_required => 'Y'
        );
        
        -- Admission Date
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_ADMISSION_DATE',
            p_item_type => 'DATE_PICKER',
            p_item_label => 'Admission Date',
            p_region_id => l_region_id,
            p_display_sequence => 50,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'ADMISSION_DATE',
            p_is_required => 'Y',
            p_date_format => 'DD-MON-YYYY HH24:MI',
            p_item_default_type => 'EXPRESSION',
            p_item_default => 'SYSDATE'
        );
        
        -- Discharge Date
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_DISCHARGE_DATE',
            p_item_type => 'DATE_PICKER',
            p_item_label => 'Discharge Date',
            p_region_id => l_region_id,
            p_display_sequence => 60,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'DISCHARGE_DATE',
            p_date_format => 'DD-MON-YYYY'
        );
        
        -- Status
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_STATUS',
            p_item_type => 'SELECT_LIST',
            p_item_label => 'Status',
            p_region_id => l_region_id,
            p_display_sequence => 70,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'STATUS',
            p_is_required => 'Y',
            p_item_default_type => 'STATIC',
            p_item_default => 'ADMITTED'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_STATUS',
            p_entry_value => 'ADMITTED',
            p_entry_display => 'Admitted'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_STATUS',
            p_entry_value => 'DISCHARGED',
            p_entry_display => 'Discharged'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 4,
            p_item_name => 'P4_STATUS',
            p_entry_value => 'CANCELLED',
            p_entry_display => 'Cancelled'
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Admission Form Items created');
    END;
    
    -- Buttons
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 4,
        p_region_name => 'Admission Buttons',
        p_region_template_id => 1,
        p_display_sequence => 100,
        p_region_type => 'STATIC_CONTENT',
        p_region_source => '
        <div class="button-group">
            <button class="btn btn-primary" onclick="document.getElementById(''P4_SAVE'').click();">
                <i class="fa fa-save"></i> Save Admission
            </button>
            <button class="btn btn-secondary" onclick="window.history.back();">
                <i class="fa fa-times"></i> Cancel
            </button>
        </div>'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Admission Form Page created');
END;
/

-- ============================================
-- Page 5: Billing Form
-- ============================================
BEGIN
    APEX_PAGE.CREATE_PAGE(
        p_flow_id => 100,
        p_page_id => 5,
        p_page_name => 'Billing Entry',
        p_page_title => 'Generate Bill - Invoice',
        p_page_mode => 'NORMAL',
        p_page_template_id => 1
    );
    
    -- Billing Header Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 5,
        p_region_name => 'Bill Header',
        p_region_template_id => 1,
        p_display_sequence => 1,
        p_region_type => 'FORM',
        p_region_source => 'MDHSYS.BILLING'
    );
    
    DECLARE
        l_region_id NUMBER;
    BEGIN
        SELECT region_id INTO l_region_id 
        FROM apex_application_page_regions 
        WHERE application_id = 100 AND page_id = 5 AND region_name = 'Bill Header';
        
        -- Bill ID
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_BILL_ID',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Bill Number',
            p_region_id => l_region_id,
            p_display_sequence => 10,
            p_read_only => 'Y',
            p_source_type => 'DB_COLUMN',
            p_source => 'BILL_ID'
        );
        
        -- Patient (LOV)
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_PATIENT_ID',
            p_item_type => 'TEXT_FIELD_WITH_LOV',
            p_item_label => 'Patient',
            p_region_id => l_region_id,
            p_display_sequence => 20,
            p_item_width => 50,
            p_source_type => 'DB_COLUMN',
            p_source => 'PATIENT_ID',
            p_is_required => 'Y'
        );
        
        -- Admission ID
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_ADMISSION_ID',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Admission ID',
            p_region_id => l_region_id,
            p_display_sequence => 30,
            p_item_width => 50,
            p_source_type => 'DB_COLUMN',
            p_source => 'ADMISSION_ID'
        );
        
        -- Bill Date
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_BILL_DATE',
            p_item_type => 'DATE_PICKER',
            p_item_label => 'Bill Date',
            p_region_id => l_region_id,
            p_display_sequence => 40,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'BILL_DATE',
            p_is_required => 'Y',
            p_item_default_type => 'EXPRESSION',
            p_item_default => 'SYSDATE'
        );
        
        -- Bill Status
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_BILL_STATUS',
            p_item_type => 'SELECT_LIST',
            p_item_label => 'Status',
            p_region_id => l_region_id,
            p_display_sequence => 50,
            p_item_width => 25,
            p_source_type => 'DB_COLUMN',
            p_source => 'BILL_STATUS',
            p_item_default_type => 'STATIC',
            p_item_default => 'PENDING'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_BILL_STATUS',
            p_entry_value => 'PENDING',
            p_entry_display => 'Pending'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_BILL_STATUS',
            p_entry_value => 'PARTIAL',
            p_entry_display => 'Partially Paid'
        );
        
        APEX_PAGE.CREATE_LIST_ENTRY(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_BILL_STATUS',
            p_entry_value => 'PAID',
            p_entry_display => 'Paid'
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Billing Form Items created');
    END;
    
    -- Bill Items Region (Detail Grid)
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 5,
        p_region_name => 'Bill Items',
        p_region_template_id => 1,
        p_display_sequence => 20,
        p_region_type => 'INTERACTIVE_GRID',
        p_region_source => 'SELECT BILL_DETAIL_ID, SERVICE_NAME, QUANTITY, UNIT_PRICE, TOTAL_AMOUNT 
                            FROM MDHSYS.BILLING_DETAILS 
                            WHERE BILL_ID = :P5_BILL_ID'
    );
    
    -- Totals Region
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 5,
        p_region_name => 'Bill Totals',
        p_region_template_id => 1,
        p_display_sequence => 30,
        p_region_type => 'STATIC_CONTENT',
        p_region_source => '
        <style>
            .totals-container {
                background: #F9FAFB;
                padding: 20px;
                border-radius: 8px;
                margin-top: 20px;
                border: 2px solid #E5E7EB;
            }
            .total-row {
                display: flex;
                justify-content: space-between;
                padding: 12px 0;
                font-size: 16px;
                border-bottom: 1px solid #E5E7EB;
            }
            .total-row:last-child {
                border-bottom: none;
            }
            .total-label {
                font-weight: 600;
                color: #1F2937;
            }
            .total-amount {
                font-weight: 600;
                color: #667eea;
            }
            .grand-total {
                font-size: 18px;
                font-weight: 700;
                color: white;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 16px;
                border-radius: 8px;
                margin-top: 12px;
            }
        </style>
        <div class="totals-container">
            <div class="total-row">
                <span class="total-label">Subtotal:</span>
                <span class="total-amount">Rs. 0</span>
            </div>
            <div class="total-row">
                <span class="total-label">Discount:</span>
                <span class="total-amount">Rs. 0</span>
            </div>
            <div class="total-row">
                <span class="total-label">Tax (17%):</span>
                <span class="total-amount">Rs. 0</span>
            </div>
            <div class="grand-total">
                <span class="total-label">Grand Total: Rs. 0</span>
            </div>
        </div>'
    );
    
    -- Payment Section
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 5,
        p_region_name => 'Payment Info',
        p_region_template_id => 1,
        p_display_sequence => 40,
        p_region_type => 'FORM',
        p_region_source => 'MDHSYS.BILLING'
    );
    
    DECLARE
        l_region_id NUMBER;
    BEGIN
        SELECT region_id INTO l_region_id 
        FROM apex_application_page_regions 
        WHERE application_id = 100 AND page_id = 5 AND region_name = 'Payment Info';
        
        -- Total Amount
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_TOTAL_AMOUNT',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Total Amount',
            p_region_id => l_region_id,
            p_display_sequence => 10,
            p_item_width => 30,
            p_source_type => 'DB_COLUMN',
            p_source => 'TOTAL_AMOUNT',
            p_is_required => 'Y'
        );
        
        -- Paid Amount
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_PAID_AMOUNT',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Paid Amount',
            p_region_id => l_region_id,
            p_display_sequence => 20,
            p_item_width => 30,
            p_source_type => 'DB_COLUMN',
            p_source => 'PAID_AMOUNT'
        );
        
        -- Balance
        APEX_PAGE.CREATE_PAGE_ITEM(
            p_flow_id => 100,
            p_page_id => 5,
            p_item_name => 'P5_BALANCE',
            p_item_type => 'TEXT_FIELD',
            p_item_label => 'Outstanding Balance',
            p_region_id => l_region_id,
            p_display_sequence => 30,
            p_item_width => 30,
            p_source_type => 'DB_COLUMN',
            p_source => 'BALANCE',
            p_read_only => 'Y'
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Billing Payment Items created');
    END;
    
    -- Action Buttons
    APEX_PAGE.CREATE_REGION(
        p_flow_id => 100,
        p_page_id => 5,
        p_region_name => 'Bill Actions',
        p_region_template_id => 1,
        p_display_sequence => 100,
        p_region_type => 'STATIC_CONTENT',
        p_region_source => '
        <div class="button-group">
            <button class="btn btn-primary" onclick="print();">
                <i class="fa fa-print"></i> Print Bill
            </button>
            <button class="btn btn-primary" onclick="document.getElementById(''P5_SAVE'').click();">
                <i class="fa fa-save"></i> Save & Record Payment
            </button>
            <button class="btn btn-secondary" onclick="window.history.back();">
                <i class="fa fa-times"></i> Cancel
            </button>
        </div>'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Billing Form Page created');
END;
/

-- ============================================
-- Global CSS Styling
-- ============================================
BEGIN
    INSERT INTO apex_application_settings (
        APPLICATION_ID, SETTING_NAME, SETTING_VALUE
    ) VALUES (
        100, 'CUSTOM_CSS', '
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: ''Segoe UI'', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #E5E7EB;
        }
        
        .form-section:last-child {
            border-bottom: none;
        }
        
        label {
            font-weight: 600;
            color: #1F2937;
            display: block;
            margin-bottom: 8px;
        }
        
        input, textarea, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #E5E7EB;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .grid-cols-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .grid-cols-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        .card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border: 1px solid #E5E7EB;
        }
        
        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-success {
            background: #D1FAE5;
            color: #065F46;
        }
        
        .badge-warning {
            background: #FEF3C7;
            color: #92400E;
        }
        
        .badge-danger {
            background: #FEE2E2;
            color: #991B1B;
        }
        
        @media (max-width: 768px) {
            .grid-cols-2, .grid-cols-3 {
                grid-template-columns: 1fr;
            }
            
            .search-grid {
                grid-template-columns: 1fr !important;
            }
        }
        '
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Global CSS applied');
END;
/

COMMIT;
DBMS_OUTPUT.PUT_LINE('✅ APEX 26 Professional Forms Created Successfully!');
