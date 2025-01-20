# **Chicago Crime Analyzer**

## **Introduction**
The **Chicago Crime Analyzer** project aims to extract meaningful insights from crime data in Chicago using advanced **data analytics and visualization techniques**. By analyzing publicly available crime datasets, this project identifies **trends, crime hotspots, and correlations** among various crime types, locations, and timeframes. 

## **Problem Statement**
Crime data in large metropolitan areas like Chicago is vast and complex, making it challenging for law enforcement agencies and policymakers to derive actionable insights. The inability to efficiently interpret crime patterns hinders resource allocation, crime prevention strategies, and public safety measures. 

This project addresses these challenges by:
- Analyzing crime trends over time.
- Identifying high-risk locations.
- Evaluating the effectiveness of arrests.
- Understanding the correlation between crime types and locations.
- Providing a data-driven approach to support law enforcement and policy decisions.
- Helping communities stay informed and make safer decisions.

## **Project Workflow**
1. **Data Retrieval**: Import crime data, including key attributes like **Primary Type, Description, Date, Location Description, Latitude, and Longitude**.
2. **Data Cleaning & Preparation**: Handle missing values, duplicates, and format inconsistencies.
3. **Exploratory Data Analysis (EDA)**: Perform **temporal, geospatial, and categorical trend analysis**.
4. **MySQL Insights**: Generate actionable insights using **SQL queries**.
5. **Power BI Dashboard**: Develop an **interactive dashboard** for crime visualization.

## **Technologies Used**
| Technology | Purpose |
|------------|---------|
| **Python** | Core programming language for data processing & analysis. [Docs](https://docs.python.org/3/) |
| **Pandas** | Data manipulation & preparation. [Docs](https://pandas.pydata.org/docs/) |
| **Plotly** | Interactive data visualization. [Docs](https://plotly.com/) |
| **MySQL** | Storing and querying crime insights. [Docs](https://dev.mysql.com/doc/) |
| **Power BI** | Creating interactive dashboards. [Docs](https://learn.microsoft.com/en-us/power-bi/) |
| **SQLAlchemy** | ORM for database interaction. |
| **Streamlit** | Web application framework for data apps. |

## **Installation & Setup**
To run this project, install the required dependencies using pip:

```bash
pip install pandas streamlit streamlit-option-menu sqlalchemy pymysql plotly-express
```

## **Project Structure**
The project consists of the following files:

### **1. `Data_Preprocessing.ipynb`**
- Imports required libraries and loads the dataset.
- Identifies and corrects misspelled words.
- Handles missing and duplicate values.
- Performs **feature engineering** to enhance data quality.
- Saves the cleaned data as `Processed_Crime_Data.csv`.
- Performs **Exploratory Data Analysis (EDA)** and generates insights.
- Loads the processed dataset into **MySQL** using `SQLAlchemy`.

### **2. `project_chicago_crime_analyser_databasestyles.sql`**
- Contains **16 SQL-based insights** extracted from the dataset.
- Refer to **`Chicago_Crime_Analyzer_Report.docx`** for detailed insights.

### **3. `crime_analyser_dashboard.pbix`**
- **Power BI dashboard** for **interactive crime trend analysis** by using Insights.

### **4. `Chicago_Crime_Analyzer_Report.docx`**
- Comprehensive report containing **detailed insights and EDA findings**.


## **Key Learnings & Takeaways**
- **Data Cleaning & Processing**: Handling missing values, duplicates, and text corrections.
- **Exploratory Data Analysis (EDA)**: Understanding crime trends through Python visualizations.
- **Database Management (MySQL)**: Querying structured crime data for insights.
- **Power BI Visualization**: Creating interactive dashboards for crime analysis.
- **Integration of Python & SQL**: Efficient data storage, querying, and analysis.
- **Data-Driven Decision Making**: Using analytics for crime prevention strategies.

## **How to Use the Project**
1. **Run Data Preprocessing**:
   - Open `Data_Preprocessing.ipynb` and execute all cells.
   - This will clean the dataset and store it in MySQL.

2. **Analyze SQL Insights**:
   - Import `project_chicago_crime_analyser_databasestyles.sql` into MySQL.
   - Run queries to explore crime trends.

3. **Use Power BI Dashboard**:
   - Open `crime_analyser_dashboard.pbix` in Power BI.
   - Interact with the dashboard to explore crime insights visually.


## **PowerBi Dashboard**

![image](https://github.com/user-attachments/assets/dfeb76c6-0ee2-4041-97ed-7ef96e86cfda)

![image](https://github.com/user-attachments/assets/b3e0d8a1-fb88-41b6-b7ce-f252d0fcaf0f)



---
**This project provides a structured, data-driven approach to crime analysis in Chicago, helping in better decision-making for law enforcement and public safety.**

