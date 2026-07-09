# APEX 26 Hospital ERP - API Documentation

## Base URL
```
https://your-instance.apexhosting.com/ords/mdhsys/api/v1
```

## Authentication
- Method: OAuth 2.0
- Token endpoint: `/auth/token`
- Required headers: `Authorization: Bearer {token}`

## Patient Management APIs

### List All Patients
```
GET /patients
Query Parameters:
  - page: 1
  - limit: 20
  - search: (optional)
```

Response:
```json
{
  "status": "success",
  "data": [
    {
      "patient_id": "P000001000",
      "patient_name": "Ahmed Ali",
      "contact_no": "03001234567",
      "created_date": "2026-07-09"
    }
  ]
}
```

### Create Patient
```
POST /patients
Body:
{
  "patient_name": "Ahmed Ali",
  "gender": "M",
  "dob": "1990-01-15",
  "contact_no": "03001234567",
  "email": "ahmed@example.com",
  "address": "123 Main St",
  "city": "Karachi"
}
```