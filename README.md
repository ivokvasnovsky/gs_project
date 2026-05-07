# 📊 dbt Project Overview

This dbt project implements a layered data warehouse architecture built on dbt core, snowflake and github actions. It supports two core business domains—**customers** and **shipments**—and delivers curated datasets for analytics and Power BI reporting, with all financial values standardized in EUR.

---

## 🧰 Tools & Technologies

- **dbt Core** – data transformation and modeling  
- **Snowflake** – data warehouse platform  
- **GitHub Actions** – CI/CD automation and deployment  

---

## 🏗️ Architecture

The project follows a **3-layer medallion-style architecture**:
- Staging
- Integration
- Mart

Key design principles:
- Star schema modeling with PK/FK relationships  
- Flat dimension structures  
- Mart layer contains **permanent, production-ready tables**  
- Strict access control using **grants and RBAC**

---

## 🌍 Environments

Each environment mirrors the same 3-layer structure:

### DEV
- DEV_L1_STAGING  
- DEV_L2_INTEGRATION  
- DEV_L3_MART  

### TEST
- TEST_L1_STAGING  
- TEST_L2_INTEGRATION  
- TEST_L3_MART  

### PROD
- PROD_L1_STAGING  
- PROD_L2_INTEGRATION  
- PROD_L3_MART  

- Environment resolution handled via `generate_database_name` macro using `{{ target.name }}`  

---

## 🗄️ Source Systems

All data originates from shared source databases:
- PINT_L0_DATASOURCES
- RAW_L0_DATASOURCES

### Sources are organized per domain:
- **common_dims**
  - customers  
  - exchange_rate  
  - geo_ref  

- **dd_reports**
  - dd_progress  

- **gre**
  - gre_linkage  
  - shipments  

- **idw**
  - revenue_details  
  - shipments  

- Each source is defined in a separate `_source.yml` file  

---

## 📦 Data Model

### Core Business Domains
- Customers  
- Shipments  

### Dimensions
- Customers  
- Geo  

### Fact Tables
- Customers snapshot fact  
- Shipments incremental fact  

Key properties:
- Stored as **permanent Snowflake tables**
- All financial measures converted to **EUR (company standard)**

---

## 🔄 CI/CD Strategy

Implemented via GitHub Actions with feature branch workflow.

### CI (Continuous Integration)
- Runs on TEST environment  
- Slim CI execution mode  
- Uses: `state:modified+` and `--defer` with production manifest from S3  
- Cloned incremental models for efficiency  

### CD (Continuous Deployment)
- Uses production manifest from S3  
- Deploys models and documentation to production  
- Documentation hosted in S3  

---

## 🧪 Testing Strategy

- Generic tests:
  - not null  
  - unique (where applicable)  
  - relationships (FK integrity)  

- Source-level testing ensures early failure detection  
- Freshness tests applied to raw sources  

---

## 📊 Semantic Layer (Power BI)

### Reports Overview

The dbt models are exposed through Power BI semantic layers supporting business reporting and financial analysis.

---

### 📈 DD Progress Report

Customer revenue progression and discount tier tracking.

#### Purpose
Tracks how customers progress through revenue-based discount tiers.

#### Business Value
- Identifies customers close to next discount level  
- Supports upsell and revenue growth actions  
- Enables discount optimization strategy  
- Provides segmentation by revenue maturity  

#### Business Logic
- Calculates revenue progress per customer  
- Computes gap to next discount level  
- Shows current discount applied  

#### Business Reasoning
This report supports tiered pricing models by showing:
- how much revenue a customer has generated,
- how close they are to the next discount threshold,
- and where sales actions can increase customer value.

👉 Report:  
https://app.powerbi.com/groups/me/reports/e96ba1d0-8132-4f56-8e18-79d0ccabeeae/d698ee6e0600d058029d?experience=power-bi  

---

### ⛽ Shipment Fuel Surcharge Report

Analysis of fuel surcharge revenue leakage by comparing actual vs simulated charges.

#### Purpose
Detects differences between expected and actual fuel surcharge billing.

#### Business Value
- Identifies revenue leakage  
- Ensures correct fuel surcharge billing  
- Validates pricing rules  
- Improves shipment profitability tracking  

#### Business Logic
- Actual fuel surcharge comes from IDW shipment data  
- Simulated surcharge is calculated using pricing logic in GRE 
- Difference defines **missed fuel surcharge**

#### Business Reasoning

Fuel surcharge compensates for fuel cost variability.
Differences indicate:

- incorrect billing
- missing surcharge application
- system or pricing inconsistencies

This report quantifies lost revenue opportunities and improves pricing accuracy.

👉 Model:
https://app.powerbi.com/groups/963d48ca-3391-4f1a-860c-7ca25ec4339e/modeling/b1f96788-74c3-4aff-b9ad-6e9d98e02502/modelView?experience=power-bi