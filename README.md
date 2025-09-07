Project title: This project contains R scripts for analyzing global COVID-19 data. 

Overview:

This project analyzes global COVID-19 data by scraping, cleaning, and performing exploratory analysis in R.  
Key tasks include:
- Web scraping with `rvest`
- Data cleaning and wrangling
- Ratio analysis (confirmed-to-population, confirmed-to-tested)
- Pattern matching with regular expressions
- Country-level risk comparisons

Tools & Skills:
R (rvest, dplyr, stringr)
Data Wrangling & Cleaning
Exploratory Data Analysis (EDA)
Regular Expressions
Conditional Logic

Insights
- Identified countries with lower infection risk (confirmed-to-population < 1% and 5%)
- Compared infection risks between Nigeria and Ghana
Files:
analysis.R`: Main script for data cleaning and visualization.  
task9.R`: Script for comparing confirmed cases to population ratio.  
task10.R`: Script for identifying countries with low infection risk.  
covid_data.csv`: Dataset of COVID-19 cases.

How to Run:
Open RStudio.  
2. Set your working directory to this folder.  
3. Run the scripts in the following order:  
   - `analysis.R`  
   - `task9.R`  
   - `task10.R` 