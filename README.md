# Hospital ERP System - APEX 26

## Overview
A comprehensive, modern Hospital Management System built with Oracle APEX 26, designed for efficient management of hospital operations including patient management, admissions, billing, and payroll.

## Features

### 🏥 Core Modules
- **Patient Management**: Complete patient lifecycle management
- **Admission & Discharge**: Streamlined admission process and discharge management
- **Bed Management**: Real-time bed allocation and tracking
- **Billing System**: Comprehensive billing with multiple payment modes
- **Payroll**: Automated salary processing and payslips
- **Attendance**: Employee attendance tracking
- **Reports**: Extensive reporting and analytics

### 💻 Technology Stack
- **Frontend**: Oracle APEX 26 (Responsive Web Interface)
- **Backend**: Oracle Database 19c+, PL/SQL Packages
- **API**: REST APIs via Oracle ORDS
- **Mobile**: Responsive Design (Mobile Compatible)

### 🔐 Security Features
- Role-based access control (RBAC)
- Department-level permissions
- Complete audit trail
- User activity logging
- Secure authentication

### 📊 Analytics & Reporting
- Real-time dashboard
- Daily census reports
- Revenue analytics
- Bed occupancy tracking
- Department-wise analysis

## Quick Start

### Prerequisites
- Oracle Database 19c or higher
- APEX 26.0 or higher
- Oracle ORDS
- Modern web browser

### Installation
```bash
# 1. Clone the repository
git clone https://github.com/mustafamajeed1149-beep/ERP.git
cd ERP

# 2. Checkout development branch
git checkout apex-26-development

# 3. Run database setup
cd database
sqlplus MDHSYS/password @MDHSYS_CORE_SCHEMA.sql

# 4. Deploy APEX application
# See INSTALLATION.md for detailed steps
```

## Project Structure
```
.
├── database/           # Database schemas and structures
├── apex/
│   ├── forms/         # APEX 26 Forms (FMB files)
│   ├── pages/         # APEX Page definitions
│   ├── api/           # REST API definitions
│   └── packages/      # PL/SQL packages
├── documentation/     # User guides and API docs
└── README.md         # This file
```

## Documentation
- [Installation Guide](documentation/INSTALLATION.md)
- [User Guide](documentation/USER_GUIDE.md)
- [API Documentation](documentation/API_DOCUMENTATION.md)

## Version
- Current Version: 26.0.1
- APEX Version: 26.0+
- Database: Oracle 19c+

## Support
- Email: support@mdhs.hospital
- Issues: GitHub Issues
- Documentation: See `/documentation` folder

## Author
**Mustafa Majeed**
- GitHub: [@mustafamajeed1149-beep](https://github.com/mustafamajeed1149-beep)
- Created: July 2026

---

**Last Updated**: July 9, 2026
**Branch**: apex-26-development