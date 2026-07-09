# APEX 26 Hospital ERP - Installation Guide

## Prerequisites
- Oracle Database 19c or higher
- APEX 26.0 or higher
- Oracle REST Data Services (ORDS)
- Web Browser (Chrome, Firefox, Safari, Edge)

## Installation Steps

### 1. Database Setup
```sql
-- Create user (if not exists)
CREATE USER MDHSYS IDENTIFIED BY your_password;
GRANT DBA TO MDHSYS;
GRANT CREATE PROCEDURE TO MDHSYS;
GRANT CREATE TRIGGER TO MDHSYS;
```

### 2. Schema Creation
```bash
# Connect to Oracle
sqlplus MDHSYS/password@database

# Run schema scripts
@database/MDHSYS_CORE_SCHEMA.sql
@apex/packages/APP_CONFIG.sql
@apex/packages/PATIENT_MANAGEMENT.sql
@apex/packages/BILLING_MANAGEMENT.sql
```

### 3. APEX Application Deployment
```bash
# Import APEX application
# In APEX Developer -> Import -> Select exported application file
# Application ID: 100 (or assign new)
```

### 4. REST API Setup
```sql
-- Create API modules in APEX
-- Dashboard
-- Patient Management
-- Admission Management
-- Billing
-- Reports
```

### 5. Initial Configuration
- Set company parameters
- Configure users and roles
- Set up email notifications
- Configure security settings

## First Login
- Username: ADMIN
- Password: (provided during setup)
- Change password on first login

## Post-Installation
1. Run initial data load
2. Configure backup schedule
3. Set up monitoring
4. Train users