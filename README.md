# E-commerce Data Analysis  

## Overview  
This is a personal project focused on cleaning, processing, and analyzing **e-commerce datasets (Sep 2016 – Oct 2018)** to uncover insights related to orders, revenue, deliveries, products, and sellers.  

The analysis is designed to help answer business questions that can guide operational improvements and strategic decision-making.  

---

## Business Task  
Analyze e-commerce datasets to answer key questions:  
- How do late deliveries affect customer satisfaction and revenue?  
- Which product categories drive the most revenue?  
- Who are the top-performing sellers?  
- What are the revenue and order trends over time?  
- Which states contribute the most customers and revenue?  

---

## Datasets  
The project uses multiple datasets including:  

- Customers Dataset  
- Geolocation Dataset  
- Orders Dataset  
- Order Items Dataset  
- Order Payments Dataset  
- Order Reviews Dataset  
- Products Dataset  
- Sellers Dataset  
- Product Category Translation Dataset  

> Note: Datasets are uploaded on kaggle due to size problem on github.

You can access these datasets from this link:
[Datasets](https://www.kaggle.com/work/datasets)

---

## Process  
The project follows a structured data analysis workflow:  

1. **Database Creation** – Setup MySQL database and tables.  
2. **Data Import** – Load raw datasets into MySQL.  
3. **Data Cleaning** – Handle null values, remove duplicates, standardize text, correct anomalies, and ensure referential integrity.  
4. **Data Analysis** – Use SQL queries to extract actionable insights.  
5. **Data Visualization** – Create dashboards in Tableau to present findings.  
6. **Reporting** – Build executive-level presentations in PowerPoint.

These all things are done in this SQL script:
[SQL Script for Data Cleaning and Analysis](./script/data_cleaning_and_analysis.sql)

---

## Key Analyses  
- **Impact of Late Deliveries** on review scores and revenue.  
- **Top Product Categories** by customer satisfaction and revenue.  
- **Top Sellers** ranked by revenue and order count.  
- **Order Trends** over time.  
- **Customer and Revenue Distribution** by state.  

---

## Tech Stack  
![MySQL](https://img.shields.io/badge/-MySQL-blue?logo=mysql&logoColor=white)  
![Tableau](https://img.shields.io/badge/-Tableau-blue?logo=tableau&logoColor=white)  
![PowerPoint](https://img.shields.io/badge/-PowerPoint-orange?logo=microsoft-powerpoint&logoColor=white)  

---

## Deliverables  
- [SQL Script for Data Cleaning and Analysis](./script/data_cleaning_and_analysis.sql)  
- [Tableau Dashboard](./dashboard/ecommerce_sales_dashboard.twb)  
- [Executive Presentation (PowerPoint)](./deliverables/Ecommerce_Analysis_Presentation.pptx)   
- [Key Insights Summary](./deliverables/Key_Insights_Report.pdf)  

---

## Sample Insights  

**Insight 1: Late Deliveries Impact**  
Late deliveries negatively affect review scores and revenue, showing the importance of delivery reliability.  

**Insight 2: Top Product Categories**  
Certain product categories consistently generate higher revenue and satisfaction, suggesting focus areas for growth.  

**Insight 3: Seller Performance**  
A small number of sellers account for a large portion of revenue, highlighting potential partnership opportunities.  

---

## Recommendations  
1. Improve delivery reliability to boost satisfaction and revenue.  
2. Focus on high-performing product categories for marketing and stock optimization.  
3. Build stronger relationships with top sellers.  
4. Use insights to improve inventory and logistics strategies.  

---

## About This Project  
This project demonstrates key data analysis skills including:  
- Database design and management  
- Data cleaning and transformation  
- SQL-based exploratory analysis  
- Data visualization with Tableau  
- Executive presentation creation  
- Business insight generation  

---

## Acknowledgements  
Thanks to publicly available datasets and data analysis resources that inspired this project.
