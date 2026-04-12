# Marketing Attribution Analysis (SQL + Power BI)

##  Overview
This project analyzes multi-channel customer journey data to evaluate how different marketing channels contribute to conversions using multiple attribution models.

It demonstrates how business decisions can vary significantly depending on the attribution logic applied, highlighting the importance of selecting the right model for marketing strategy.

##  Objective
To identify the role of different marketing channels in user acquisition and conversion, and compare how attribution models impact channel performance evaluation.

##  Tools Used
- SQL (MySQL)
- Power BI

##  Key Features
- First-Touch, Last-Touch, and Linear Attribution Models
- Conversion Funnel Analysis (~41% conversion rate)
- Channel Performance Comparison
- Interactive Power BI Dashboard

##  Process

1. **Data Transformation (SQL)**
   - Converted raw journey data into event-level format (click vs conversion)
   - Created structured dataset for attribution analysis

2. **Attribution Modeling**
   - First-Touch Attribution
   - Last-Touch Attribution
   - Linear Attribution

3. **Analysis**
   - Channel performance comparison
   - Conversion funnel analysis (~41% conversion rate)
   - User journey path evaluation

4. **Visualization**
   - Built interactive Power BI dashboard to compare attribution models and channel contributions

##  Key Insights
- Email acts as a primary acquisition channel (first-touch)
- Google dominates conversion stage (last-touch & linear attribution)
- Attribution models significantly change channel importance
  
##  Business Conclusion

- Relying on a single attribution model can lead to **misleading decisions**
- Email is effective for driving initial engagement, while Google is critical for closing conversions
- A **multi-channel strategy** is necessary for optimizing marketing performance

## ❓ Why this project matters

Choosing the wrong attribution model can result in poor budget allocation and ineffective marketing strategies.  

##  Project Structure
- /Result_tables → Final result tables
- /Project.sql → SQL queries for transformation & attribution
- /powerbi → [Dashboard file] 

Dataset: [Data](https://drive.google.com/file/d/1WxjNJzbyZqLyMK6Ykr0lISOoCyQKCfDm/view?usp=drive_link)

Dataset Source: Kaggle

##  Dashboard Preview
<img width="889" height="514" alt="image" src="https://github.com/user-attachments/assets/9278e5cd-4da1-4034-bcd6-3bbd659148ed" />

