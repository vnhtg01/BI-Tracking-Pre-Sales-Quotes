# Business Intelligence Project - Dashboard For Tracking a Company's Pre-sales Quotes

This project aims to build a **datamart** and **Power BI dashboards** to analyze **pre-sales quotes** for the fictitious company IT4Logs.

### Objectives:

* Monitor commercial performance (total and average quotes HT/TTC, etc.)
* Analyze quotes by key dimensions: client, salesperson, product, status, and date
* Support strategic decision-making with interactive dashboards

### Tech Stack:

* **Odoo**: Simulated quote data generation
* **Talend**: ETL integration (Odoo view + simulated JSON API → PostgreSQL)
* **PostgreSQL**: Star schema model (raw → staging → ODS → DWH)
* **Power BI**: KPI visualization and dynamic reports

### Power BI Pages:

* Home & navigation
![image](https://github.com/user-attachments/assets/436a8eac-9b8a-4f32-bb44-d2afcc98fad6)

* Overview
![image](https://github.com/user-attachments/assets/ef47b7d5-86bd-4fe6-9094-b8066c6236d5)

* Quote amounts (HT/TTC and trends)
![image](https://github.com/user-attachments/assets/2ff5da80-5e33-4881-a50c-15fa52e7a537)
  
* Clients (city/state breakdown)
![image](https://github.com/user-attachments/assets/69cd6ea2-986d-4688-ad33-fe0f3e705bb2)
  
* Sales performance (individual KPIs)
![image](https://github.com/user-attachments/assets/c85054c5-778e-4248-a991-60489f8315c9)

* Product & Quote Status
![image](https://github.com/user-attachments/assets/167e139c-68ab-4214-9c54-44af0d6f4cc4)
