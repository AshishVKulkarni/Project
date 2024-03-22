

#data.dir <- "local path"
#wine <- read.csv(paste0(data.dir,"freeport-2014-2018.csv"))

head(wine)

# Load required libraries
library(dplyr)
library(ggplot2)
library(maps)

# Assuming 'wine_data' is your dataset

# Step 1: Aggregate data by state
wine_by_state <- wine %>%
  group_by(state) %>%
  summarise(TotalProfits = sum(sale.profit, na.rm = TRUE),
            AverageDiscount = mean(discount.pct, na.rm = TRUE),
            UniqueWines = n_distinct(wine))

# Step 2: Get state map data
state_map <- map_data("state")

# Merge wine data with state map data
state_map_wine <- left_join(state_map, wine_by_state, by = c("region" = "state"))

# Function to create choropleth map
create_choropleth <- function(data, variable, title) {
  ggplot(data = data, aes(x = long, y = lat, group = group, fill = get(variable))) +
    geom_polygon(color = "white") +
    scale_fill_viridis_c() +
    theme_minimal() +
    labs(title = title) +
    theme(legend.position = "right")
}

# Create choropleth map for profits
profits_map <- create_choropleth(state_map_wine, "TotalProfits", "Total Profits by State")

# Create choropleth map for average discount
discounts_map <- create_choropleth(state_map_wine, "AverageDiscount", "Average Discount by State")

# Create choropleth map for unique wine choices
wines_map <- create_choropleth(state_map_wine, "UniqueWines", "Unique Wine Choices by State")

# Display the maps
profits_map
discounts_map
wines_map


#################### COMBINED MAP #########################
library(ggplot2)
library(dplyr)

# Step 1: Calculate total profits and discounts by state
wine_by_state <- wine %>%
  group_by(state) %>%
  summarise(TotalProfits = sum(sale.profit, na.rm = TRUE),
            TotalDiscounts = sum(discount.pct * sale.profit, na.rm = TRUE))

# Step 2: Get state map data
state_map <- map_data("state")

# Merge wine data with state map data
state_map_wine <- left_join(state_map, wine_by_state, by = c("region" = "state"))

# Step 3: Define custom color palette for profits and discounts
wine_colors <- c("#6b0e0e", "#a31515", "#d45555", "#ff6f6f", "#ff9999", "#ffb3b3")

# Function to create choropleth map with custom palette for profits and discounts
create_choropleth_combined <- function(data, variable, title) {
  ggplot(data = data, aes(x = long, y = lat, group = group, fill = get(variable))) +
    geom_polygon(color = "white") +
    scale_fill_gradientn(colors = wine_colors) +
    theme_minimal() +
    labs(title = title) +
    theme(legend.position = "right")
}

# Create choropleth map for combined profits and discounts
combined_map <- create_choropleth_combined(state_map_wine, "TotalProfits", "Profits and Discounts by State")

# Display the map
print(combined_map)


############################################################

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Convert 'date' column to a Date format
wine$date <- as.Date(wine$date, format = "%m/%d/%Y")

# Create a time series plot for regional growth
ggplot(wine, aes(x = date, y = sale.profit, color = region)) +
  geom_point() +
  labs(title = "Regional Growth Over Time", x = "Date", y = "Sale Profit") +
  theme_minimal() +
  facet_wrap(~ region, ncol = 1, scales = "free_x") +
  theme(
    axis.title.x = element_text(margin = margin(t = 10)),  # Add margin to x-axis title
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels for better visibility
    axis.ticks.x = element_blank(),
    strip.text = element_text(size = 10)  # Adjust facet label size
  ) +
  guides(color = FALSE)


ggplot(wine, aes(x = date, y = sale.profit, color = region)) +
  geom_point() +
  labs(title = "Regional Growth Over Time", x = "Date", y = "Sale Profit") +
  theme_minimal() +
  facet_wrap(~ region, scales = "free_x") +
    # This removes the legend for region


# Create a time series plot for rising/falling profits
ggplot(wine, aes(x = date, y = sale.profit, color = region)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Rising/Falling Profits Over Time", x = "Date", y = "Sale Profit") +
  theme_minimal()

##############################################

# Load required libraries
library(dplyr)
library(ggplot2)

# Assuming 'rep' represents the employees and 'sale.profit' is the performance metric
employee_performance <- wine %>%
  group_by(rep) %>%
  summarise(TotalProfit = sum(sale.profit, na.rm = TRUE))

# Create a bar plot to visualize performance rates
ggplot(data = employee_performance, aes(x = rep, y = TotalProfit)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Employee Performance", x = "Employee", y = "Total Profit") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


##########################################################

# Load required libraries
library(dplyr)
library(ggplot2)

# Assuming 'rep' represents the employees and 'sale.profit' is the performance metric
employee_performance_by_region <- wine %>%
  group_by(rep, region) %>%
  summarise(TotalProfit = sum(sale.profit, na.rm = TRUE))

# Create a bar plot to visualize performance rates by region
ggplot(data = employee_performance_by_region, aes(x = rep, y = TotalProfit, fill = region)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Employee Performance by Region", x = "Employee", y = "Total Profit") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")  # You can choose a different color palette if desired
##################################################
# Load required libraries
library(dplyr)
library(ggplot2)

# Assuming 'rep' represents the employees and 'sale.profit' is the performance metric
employee_profit_by_region <- wine %>%
  group_by(rep, region) %>%
  summarise(TotalProfit = sum(sale.profit, na.rm = TRUE))

# Create a grouped bar plot to visualize profits by region for each employee
ggplot(data = employee_profit_by_region, aes(x = region, y = TotalProfit, fill = rep)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  labs(title = "Employee Profit by Region", x = "Region", y = "Total Profit", fill = "Employee") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")  # You can choose a different color palette if desired


# Calculate total profit by region
total_profit_by_region <- wine %>%
  group_by(region) %>%
  summarise(TotalProfit = sum(sale.profit, na.rm = TRUE))

# Create a bar plot
ggplot(data = total_profit_by_region, aes(x = region, y = TotalProfit)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Total Profit by Region", x = "Region", y = "Total Profit") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Calculate total profit by region and employee
ggplot(data = total_profit_by_employee, aes(x = region, y = TotalProfit, fill = rep)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), color = "white") +
  labs(title = "Total Profit by Region and Employee", x = "Region", y = "Total Profit") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c(
    "Kym Velarde" = "blue",
    "Nikky Blast" = "red",
    "Eura Begay" = "green",
    "Virgilio Mcelligott" = "purple"
  ))

# Calculate total profit by region and rep
total_profit_by_region_rep <- wine %>%
  group_by(rep, region) %>%
  summarise(TotalProfit = sum(sale.profit, na.rm = TRUE))

# Create a grouped bar plot with color by region
ggplot(data = total_profit_by_region_rep, aes(x = rep, y = TotalProfit, fill = region)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Profit by Region and Employee", x = "Representative", y = "Total Profit") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("North" = "blue", "South" = "red", "East" = "green", "West" = "purple"))


##########################################
# different regions sell different wines at different rates? How does this affect their profits?
# Step 1: Prepare the data
wine_sales <- wine %>%
  group_by(region, wine) %>%
  summarise(SalesRate = sum(units.sold) / n(), TotalProfit = sum(sale.profit, na.rm = TRUE))

# Step 2: Create the scatter plot
ggplot(data = wine_sales, aes(x = SalesRate, y = TotalProfit, color = region)) +
  geom_point(shape = 16, size = 4) +
  scale_color_manual(values = c("#8B0000", "#990000", "#A52A2A", "#B22222", "red3"))+
  labs(title = "Profit vs. Sales Rate by Region and Wine",
       x = "Sales Rate", y = "Total Profit") +
  theme_minimal()
