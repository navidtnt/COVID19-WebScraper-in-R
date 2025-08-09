library(ggplot2)

# Comparison of COVID-19 Tested and Confirmed Cases in the Top 10 Testing Countries

top_countries <- new_covid_data_frame %>%
  arrange(desc(tested)) %>%
  head(10) %>%
  select(country, tested, confirmed) %>%
  pivot_longer(cols = c(tested, confirmed), names_to = "Metric", values_to = "Count")

ggplot(top_countries, aes(x = reorder(country, -Count), y = Count, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Top 10 Countries: Tested vs Confirmed COVID-19 Cases",
       x = "Country", y = "Number of Cases") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Scatter Plot (Confirmed-to-Population Ratio vs Tested-to-Population Ratio)
ggplot(new_covid_data_frame, aes(x = tested.population.ratio, y = confirmed.population.ratio)) +
  geom_point(color = "blue", alpha = 0.6) +
  labs(title = "COVID-19 Confirmed vs Tested Ratio by Population",
       x = "Tested per 100 people",
       y = "Confirmed per 100 people") +
  theme_minimal()

# Histogram (Distribution of Positive Test Ratios)
ggplot(new_covid_data_frame, aes(x = confirmed.tested.ratio)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Confirmed/Tested Ratios Across Countries",
       x = "Confirmed / Tested (%)",
       y = "Number of Countries") +
  theme_minimal()

# Pie chart showing confirmed cases distribution among top 5 countries
library(scales) # for percent_format()

top5 <- new_covid_data_frame %>%
  arrange(desc(confirmed)) %>%
  slice(1:5) %>%
  mutate(percentage = confirmed / sum(confirmed) * 100)

ggplot(top5, aes(x = "", y = percentage, fill = country)) +
  geom_col(color = "black") +
  coord_polar(theta = "y") +
  geom_text(aes(label = paste0(country, "\n", round(percentage, 1), "%")),
            position = position_stack(vjust = 0.5), size = 4) +
  labs(title = "Top 5 Countries Confirmed Cases Share (Global)") +
  theme_void()


# CDF plot to show distribution of testing coverage among countries
ggplot(new_covid_data_frame, aes(x = tested.population.ratio)) +
  stat_ecdf(geom = "step", color = "darkgreen") +
  labs(title = "Cumulative Distribution of Tested Population Ratio",
       x = "Tested Population Ratio (%)",
       y = "Cumulative Probability") +
  theme_minimal()


install.packages("reshape2")
library(ggplot2)
library(dplyr)

# Prepare data
heatmap_data <- new_covid_data_frame %>%
  select(country, confirmed.tested.ratio) %>%
  arrange(desc(confirmed.tested.ratio))

# Plot heatmap with warm-to-cool color scale (red = high, blue = low)
ggplot(heatmap_data, aes(x = 1, y = reorder(country, confirmed.tested.ratio), fill = confirmed.tested.ratio)) +
  geom_tile(color = "white") +  # white border for clarity
  scale_fill_gradientn(
    colors = c("#4575b4", "#91bfdb", "#fee08b", "#fc8d59", "#d73027"),  # blue to red
    name = "Confirmed/Tested (%)",
    labels = scales::percent_format(scale = 1),
    limits = c(min(heatmap_data$confirmed.tested.ratio, na.rm = TRUE),
               max(heatmap_data$confirmed.tested.ratio, na.rm = TRUE))
  ) +
  labs(
    title = "Heatmap of Confirmed to Tested Ratio by Country",
    x = "",
    y = "Country"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid = element_blank()
  )


# Prepare data: Select top 20 countries by confirmed.tested.ratio
top_countries <- new_covid_data_frame %>%
  arrange(desc(confirmed.tested.ratio)) %>%
  slice(1:20)

# Plot heatmap
ggplot(top_countries, aes(x = 1, y = reorder(country, confirmed.tested.ratio), fill = confirmed.tested.ratio)) +
  geom_tile(color = "white") +  # white grid lines for clarity
  scale_fill_gradientn(
    colors = c("#4575b4", "#91bfdb", "#fee08b", "#fc8d59", "#d73027"), # blue to red
    name = "Confirmed/Tested (%)",
    labels = scales::percent_format(scale = 1)
  ) +
  labs(
    title = "Top 20 Countries by Confirmed to Tested Ratio",
    x = "",
    y = "Country"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),           # Hide x-axis text
    axis.ticks.x = element_blank(),          # Hide x-axis ticks
    axis.text.y = element_text(size = 10),  # Make y-axis text bigger
    plot.title = element_text(hjust = 0.5)  # Center the title
  )

#boxplot
install.packages("countrycode")
library(countrycode)  # to map countries to continents

# Add a continent column using countrycode package
new_covid_data_frame <- new_covid_data_frame %>%
  mutate(continent = countrycode(sourcevar = country,
                                 origin = "country.name",
                                 destination = "continent"))

# Check for any countries with missing continent
missing_continent <- new_covid_data_frame %>%
  filter(is.na(continent)) %>%
  select(country) %>%
  distinct()

print("Countries with missing continent info:")
print(missing_continent)

# manually assign continents for missing countries if needed:
# new_covid_data_frame$continent[new_covid_data_frame$country == "Kosovo"] <- "Europe"
# (Add more manual fixes here if needed)

# Create boxplot
ggplot(new_covid_data_frame, aes(x = continent, y = confirmed.tested.ratio, fill = continent)) +
  geom_boxplot() +
  labs(title = "Boxplot of Confirmed/Tested Ratio by Continent",
       x = "Continent",
       y = "Confirmed to Tested Ratio (%)") +
  theme_minimal() +
  theme(legend.position = "none")


# Load necessary libraries
library(ggplot2)
library(dplyr)

# Create sample data: daily COVID tests over 30 days
set.seed(123)
sample_data <- data.frame(
  date = seq.Date(from = as.Date("2023-01-01"), by = "day", length.out = 30),
  tested = round(runif(30, min = 1000, max = 5000))
)

# View first rows of sample data
head(sample_data)

# Plot time series of tests
ggplot(sample_data, aes(x = date, y = tested)) +
  geom_line(color = "blue") +       # Line connecting points
  geom_point(color = "darkblue", size = 2) +  # Points on each day
  labs(title = "Daily COVID-19 Tests Over Time",
       x = "Date",
       y = "Number of Tests") +
  theme_minimal() +                 # Clean minimal theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate dates for clarity

