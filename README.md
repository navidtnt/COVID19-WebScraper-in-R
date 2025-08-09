# 🌐 COVID19-WebScraper-in-R

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
[![R Version](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg)](https://cran.r-project.org/)  
[![Made with R](https://img.shields.io/badge/Made%20with-R-blue?logo=r&logoColor=white)](https://www.r-project.org/)

---

## 📖 Introduction

This project demonstrates **web scraping** in R to extract **global COVID-19 case data** from Wikipedia.  
The scraped data is **cleaned, saved to CSV, and visualized** using bar charts for quick interpretation.  

**Why this project?**  
In the era of big data, being able to automatically extract, process, and visualize information from the web is an essential skill for data scientists and analysts.

---

## 🛠 Technologies Used

- **[R](https://www.r-project.org/)** – Main programming language  
- **[rvest](https://cran.r-project.org/web/packages/rvest/index.html)** – For web scraping  
- **[dplyr](https://dplyr.tidyverse.org/)** – For data manipulation  
- **[ggplot2](https://ggplot2.tidyverse.org/)** – For data visualization  

---

## 🚀 Features

✔ Extracts up-to-date COVID-19 case numbers from Wikipedia  
✔ Cleans and formats the dataset  
✔ Saves results locally as CSV  
✔ Generates a bar chart for visual insights  

---

## 📷 Preview Output

**Example Visualization**:  

**Comparison of COVID-19 Tested and Confirmed Cases in the Top 10 Testing Countries**
![Comparison of COVID-19 Tested and Confirmed Cases in the Top 10 Testing Countries](image_001.png)

**Relationship Between Testing Coverage and Confirmed Case Rates Across Countries**
![Relationship Between Testing Coverage and Confirmed Case Rates Across Countries](image_002.png)

**Distribution of COVID-19 Positive Test Ratios Across Countries Worldwide**
![Distribution of COVID-19 Positive Test Ratios Across Countries Worldwide](image_003.png)

---

## 📋 Example Output Data

### Sample Extracted Data from the COVID-19 Table on Wikipedia **TASK 2**


| Country or region | Date         | Tested      | Confirmed(cases) | Confirmed/tested,% |
|-------------------|--------------|-------------|------------------|--------------------|
| Afghanistan       | 17 Dec 2020  | 154,767     | 49,621           | 32.1               |
| Albania           | 18 Feb 2021  | 428,654     | 96,838           | 22.6               |
| Algeria           | 2 Nov 2020   | 230,553     | 58,574           | 25.4               |
| Andorra           | 23 Feb 2022  | 300,307     | 37,958           | 12.6               |
| Angola            | 2 Feb 2021   | 399,228     | 20,981           | 5.3                |
| Antigua and Barbuda| 6 Mar 2021   | 15,268      | 832              | 5.4                |
| Argentina         | 16 Apr 2022  | 35,716,069  | 9,060,495        | 25.4               |
| Armenia           | 29 May 2022  | 3,099,602   | 422,963          | 13.6               |
| Australia         | 9 Sep 2022   | 78,548,492  | 10,112,229       | 12.9               |
| Austria           | 1 Feb 2023   | 205,817,752 | 5,789,991        | 2.8                |


*(Values above are just sample data — actual values come from Wikipedia.)*


### Summary of COVID-19 Testing and Confirmed Cases by Country **TASK 3**
| Country               | Date         | Tested  | Confirmed | Confirmed/Tested (%) | Tested/Population (%) | Confirmed/Population (%) |
|-----------------------|--------------|---------|-----------|---------------------|----------------------|-------------------------|
| Afghanistan           | 17 Dec 2020  | 154,767 | 49,621    | 32.1                | 0.40                 | 0.13                    |
| Albania               | 18 Feb 2021  | 428,654 | 96,838    | 22.6                | 15.00                | 3.40                    |
| Algeria               | 2 Nov 2020   | 230,553 | 58,574    | 25.4                | 0.53                 | 0.13                    |
| Andorra               | 23 Feb 2022  | 300,307 | 37,958    | 12.6                | 387.00               | 49.00                   |
| Angola                | 2 Feb 2021   | 399,228 | 20,981    | 5.3                 | 1.30                 | 0.067                   |
| Antigua and Barbuda   | 6 Mar 2021   | 15,268  | 832       | 5.4                 | 15.90                | 0.86                    |


### Worldwide COVID-19 Testing Summary

| Metric                 | Value           |
|------------------------|-----------------|
| Total Confirmed Cases  | 431,434,555     |
| Total Tested Cases     | 5,396,881,644   |
| Positive Ratio         | 0.07994 (7.99%) |



---


## ▶️ Run the Project in Google Colab

You can run this project directly in your browser without installing anything:  

[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1EiVVzT1aP3byMNzeBsrVWF4W0-F65oI_#scrollTo=MKqpwKKPP51H)



## ⚙️ How to Run
1. Load the libraries

```r
library(rvest)
library(dplyr)
library(ggplot2)
```
2. Read the Wikipedia page
   
```r
url <- "https://en.wikipedia.org/wiki/List_of_countries_by_COVID-19_cases"
page <- read_html(url)

```
  
3. Extract the data table

```r
table <- page %>% html_node("table") %>% html_table(fill = TRUE)
```

4. Clean and save the data

```r
covid_data <- table %>%
  select(Country = 1, Cases = 2) %>%
  filter(!is.na(Cases)) %>%
  mutate(Cases = as.numeric(gsub(",", "", Cases)))

write.csv(covid_data, "covid19.csv", row.names = FALSE)

```

5. Visualize the data
   
```r
ggplot(covid_data, aes(x = reorder(Country, -Cases), y = Cases)) +
  geom_bar(stat = "identity", fill = "#0073C2FF") +
  coord_flip() +
  labs(
    title = "COVID-19 Cases by Country",
    x = "Country",
    y = "Number of Cases"
  ) +
  theme_minimal()


```

## 📂 Project Structure

The project directory contains the following files:



📌 **Details**:  
- **IBM Project.R** – Core script where the web scraping process is implemented using `rvest`, data is processed with `dplyr`, and visualizations are generated using `ggplot2`.  
- **covid19.csv** – CSV file generated by the script containing the cleaned dataset.  
- **README.md** – This documentation file, explaining the project, installation, and usage.  


## 🔮 Future Improvements
- Scrape multiple data tables (e.g., deaths, vaccination rates)
- Automate daily updates and store data historically
- Deploy as an interactive dashboard with Shiny

🙏 Credits
Data source: Wikipedia – List of countries by COVID-19 cases

Author: Navid
