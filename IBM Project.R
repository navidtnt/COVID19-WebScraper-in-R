#TASK 1: Get a COVID-19 pandemic Wiki page using HTTP request

library(tidyverse)
library(httr)
library(rvest)

get_wiki_covid19_page <- function() {
  
  # Wiki page base
  wiki_base_url <-  "https://en.wikipedia.org/w/index.php"
  wiki_params <- list(title = "Template:COVID-19_testing_by_country")
  
  
  # - Use the `GET` function in httr library with a `url` argument and a `query` arugment to get a HTTP response
  wiki_response <- GET(wiki_base_url, query = wiki_params) 
  
  # Use the `return` function to return the response
  return(wiki_response)
}

# Call the get_wiki_covid19_page function and print the response
wiki_covid19_response <- get_wiki_covid19_page()

print(wiki_covid19_response)

#TASK 2: Extract COVID-19 testing data table from the wiki HTML page
# Get the root html node from the http response in task 1 
wiki_covid19_page_root_node <- read_html(wiki_covid19_response)
# Get all table nodes in the root HTML node
wiki_covid19_page_table_nodes <- html_nodes(wiki_covid19_page_root_node, "table")
# Access the specific table node you want (in this case, table at index 2)
desired_table_node <- wiki_covid19_page_table_nodes[[2]]
# Read the table into a data frame
desired_table_df <- as.data.frame(html_table(desired_table_node))
desired_table_df



#TASK 3: Pre-process and export the extracted data frame
# Print the summary of the data frame
summary(desired_table_df)

preprocess_covid_data_frame <- function(data_frame) {
  
  shape <- dim(data_frame)
  
  # Remove the World row
  data_frame<-data_frame[!(data_frame$`Country or region`=="World"),]
  # Remove the last row
  data_frame <- data_frame[1:172, ]
  
  # We dont need the Units and Ref columns, so can be removed
  data_frame["Ref."] <- NULL
  data_frame["Units[b]"] <- NULL
  
  # Renaming the columns
  names(data_frame) <- c("country", "date", "tested", "confirmed", "confirmed.tested.ratio", "tested.population.ratio", "confirmed.population.ratio")
  
  # Convert column data types
  data_frame$country <- as.factor(data_frame$country)
  data_frame$date <- as.factor(data_frame$date)
  data_frame$tested <- as.numeric(gsub(",","",data_frame$tested))
  data_frame$confirmed <- as.numeric(gsub(",","",data_frame$confirmed))
  data_frame$'confirmed.tested.ratio' <- as.numeric(gsub(",","",data_frame$`confirmed.tested.ratio`))
  data_frame$'tested.population.ratio' <- as.numeric(gsub(",","",data_frame$`tested.population.ratio`))
  data_frame$'confirmed.population.ratio' <- as.numeric(gsub(",","",data_frame$`confirmed.population.ratio`))
  
  return(data_frame)
}

# call `preprocess_covid_data_frame` function and assign it to a new data frame
new_covid_data_frame <- preprocess_covid_data_frame(desired_table_df)

head(new_covid_data_frame)
# Print the summary of the processed data frame again
summary(new_covid_data_frame)

# Export the data frame to a csv file
write.csv(new_covid_data_frame, "covid19.csv")


#Task 4: Get a subset of the COVID-19 data frame (2 pts) 

# Read covid_data_frame_csv from the csv file
covid_data_frame_csv <- read.csv("covid19.csv", header=TRUE, sep=",")

# Get the 5th to 10th rows, with three "country" "tested" "confirmed" columns
covid_data_frame_row <- covid_data_frame_csv %>% select(country, tested, confirmed)
covid_data_frame_row[c(5:10), ]

#Task 5: Calculate worldwide COVID-19 testing positive ratio (2 pts)

# Get the total confirmed cases worldwide
total_confirmed_cases <- sum(covid_data_frame_csv$confirmed)
print(paste("total_confirmed_cases:", total_confirmed_cases))

# Get the total tested cases worldwide
total_tested_cases <- sum(covid_data_frame_csv$tested)
print(paste("total_tested_cases:", total_tested_cases))


# Get the positive ratio (confirmed / tested)
positive_ratio <- total_confirmed_cases / total_tested_cases
print(paste("positive_ratio:", positive_ratio))

#Task 6: Get a sorted name list of countries that reported their testing data (2 pts)

# Get the `country` column
head(covid_data_frame_csv$country)

# Check its class (should be Factor)
class(covid_data_frame_csv$country)

# Conver the country column into character so that you can easily sort them
covid_data_frame_csv$country <- as.character(covid_data_frame_csv$country)
covid_data_frame_csv$country <- covid_data_frame_csv$country %>% modify_if(is.factor, as.character)

# Sort the countries AtoZ
covid_data_frame_csv %>% arrange(country)
# Sort the countries ZtoA
sort(covid_data_frame_csv$country, decreasing = TRUE)
# Print the sorted ZtoA list
sort(covid_data_frame_csv$country, decreasing = TRUE)

#Task 7: Identify countries names with a specific pattern (2 pts)

# Use a regular expression `United.+` to find matches
matched_country <- grep("United.+", covid_data_frame_csv$country)

# Print the matched country names
covid_data_frame_csv$country[matched_country]

#Task 8: Pick two countries you are interested in, and then review their testing data (2 pts)

#selected country name and columns
covid_data_frame_italy <- covid_data_frame_csv %>% select(country, confirmed, confirmed.population.ratio) %>% 
  filter(country == "Italy")

#selected country name and columns
covid_data_frame_Netherlands <- covid_data_frame_csv %>% select(country, confirmed, confirmed.population.ratio) %>%
  filter(country == "Netherlands")

covid_data_frame_italy
covid_data_frame_Netherlands

#Task 9: Compare which one of the selected countries has a larger ratio of confirmed cases to population (2 pts)

# Use if-else statement
if (covid_data_frame_italy$confirmed.population > covid_data_frame_Netherlands$confirmed.population) {
  print("Italy has higher COVID-19 confirmed population")
} else {
  print("Netherlands has higher COVID-19 confirmed population")
}


#Task 10: Filter countries with confirmed-to-population ratio rate less than a threshold (2 pts)

# a subset of countries with `confirmed.population.ratio` less than the threshold 1%
subset(covid_data_frame_csv, subset = confirmed.population.ratio < 1)



