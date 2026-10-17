# 💳 FinTech Payment Processing System - Database Architecture

A production-ready, highly scalable, and secure relational database schema for a **FinTech Payment Processing System** built using **SQL Server (T-SQL)**.

This system is engineered to handle multi-party payment operations including customers, merchants, transaction routing, fee structures, multi-currency processing, risk management, fraud alerts, and full system auditing.

---

## 📐 Database Architecture Overview

The database is modularized into **6 core functional domains** to maintain strict separation of concerns, high integrity, and optimal query performance:

```
                  ┌─────────────────────────┐
                  │   Identity & Access     │
                  │     (Roles, Users)      │
                  └────────────┬────────────┘
                               │
   ┌───────────────────────────┼───────────────────────────┐
   │                           │                           │
┌──┴─────────────┐    ┌────────┴────────┐    ┌─────────────┴──┐
│ Core Entities  │    │ Payment Engine  │    │ Risk & Audit   │
│ (Customers,    ├────► (Payments,      ├────► (Fraud,        │
│  Merchants)    │    │  Transactions)  │    │  AuditLogs)    │
└────────────────┘    └────────┬────────┘    └────────────────┘
                               │
                      ┌────────┴────────┐
                      │    Financial    │
                      │  (Settlements,  │
                      │   Currencies)   │
                      └─────────────────┘
```

---

## 🗂️ Modules & Tables Breakdown

### 1. 🔐 Identity & Access Management (IAM)
Manages internal system users, administrative access, and role-based access control (RBAC).
* **`Roles`**: Defines permissions and role levels (`Super Admin`, `Risk Manager`, etc.).
* **`Users`**: Stores administrative users and internal staff credentials with password hashing.

### 2. 👥 Core Business Entities
Represents the primary actors interacting within the payment network.
* **`Customers`**: Stores customer demographic information, contact details, and KYC status (`Verified`, `Pending`).
* **`Merchants`**: Stores onboarding details, company information, unique merchant codes, and status.

### 3. 💳 Payment Processing Engine
The core transactional ledger tracking payment attempts, status transitions, and gateway responses.
* **`PaymentMethods`**: Customer saved cards and payment tokens (`Tokenized` for PCI-DSS compliance).
* **`Payments`**: Master payment ledger capturing payment reference, amount, currency, and client metadata (IP, User-Agent).
* **`PaymentAttempts`**: Tracks individual payment attempts against payment gateways (handles retries).
* **`Transactions`**: Finalized successful financial transactions containing net amounts and provider transaction IDs.

### 4. 🏦 Financial & Settlement Module
Handles multi-currency conversions, fee calculations, and merchant payouts.
* **`Currencies`**: Supported currency codes (ISO 4217 like USD, EGP, EUR) and symbols.
* **`ExchangeRates`**: FX rates supporting high decimal precision (`DECIMAL(18,6)`).
* **`MerchantFees`**: Configurable fee structures (Fixed + Percentage rates with Min/Max limits) per merchant and payment method.
* **`Settlements`**: Payout tracking for merchants calculating Gross Amount, Fee Deductions, and Net Settlement Amount.

### 5. 🛡️ Risk, Fraud & Disputes
Guards the system against fraudulent transactions and manages chargeback lifecycles.
* **`FraudRules`**: Rules configuration engine (e.g., Velocity checks, High amount thresholds).
* **`FraudAlerts`**: Triggered alerts with calculated risk scores for suspicious transactions.
* **`Refunds`**: Full and partial refund tracking tied directly to transactions.
* **`Disputes`**: Chargeback and dispute management lifecycle tracking.

### 6. 📜 Audit & System Logs
Ensures compliance and full system traceability.
* **`AuditLogs`**: Immutable log of entity state changes (Old Value vs New Value) made by internal users.
* **`SystemEvents`**: High-level background events and system health logs.

---

## 🛠️ Tech Stack & Key Design Features

* **Database Engine**: Microsoft SQL Server (Transact-SQL)
* **PCI-DSS Compliant Storage**: Card details stored as `CardLast4` with tokenization placeholders (`Token`).
* **High Precision Financials**: Currency amounts use `DECIMAL(18,2)` and exchange rates use `DECIMAL(18,6)` to prevent rounding errors.
* **Optimized Storage**: Binary flags (`BIT`) for boolean indicators (`IsActive`, `IsDefault`) to minimize row size.
* **Microsecond Timestamp Precision**: Uses `DATETIME2` with `SYSDATETIME()` for high-concurrency order logging.

---

## 🚀 Getting Started

### Prerequisites
* Microsoft SQL Server 2019+ or Azure SQL Database
* SQL Server Management Studio (SSMS) or Azure Data Studio

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/MARWAN-SALAMA-HASSAN/fintech-database-system.git
   cd fintech-database-system
   ```

2. **Run Schema Initialization Script:**
   Open and execute `00_InitDB.sql` in SSMS to build all tables, primary keys, and foreign key constraints in sequence.

3. **Insert Seed / Test Data:**
   Open and execute `01_TestData.sql` to populate initial test data (Roles, Currencies, Sample Merchants, and Payments).

4. **Verify Setup:**
   Run the following verification query:
   ```sql
   SELECT 
       p.PaymentReference,
       c.FullName AS CustomerName,
       m.CompanyName AS MerchantName,
       cur.CurrencyCode,
       p.Amount,
       p.Status AS PaymentStatus,
       t.NetAmount,
       t.Status AS TransactionStatus
   FROM Payments p
   JOIN Customers c ON p.CustomerID = c.CustomerID
   JOIN Merchants m ON p.MerchantID = m.MerchantID
   JOIN Currencies cur ON p.CurrencyID = cur.CurrencyID
   LEFT JOIN PaymentAttempts pa ON p.PaymentID = pa.PaymentID
   LEFT JOIN Transactions t ON pa.PaymentAttemptID = t.PaymentAttemptID;
   ```

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
