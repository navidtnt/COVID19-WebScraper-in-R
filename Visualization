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
