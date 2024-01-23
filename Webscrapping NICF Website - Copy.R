library(rvest)
library(dplyr)
setwd("C:/Users/coded/Desktop/R Demo Projects/Web Scrapping NICF Website/")
getwd()

# Function to extract startup details from a given page
get_startup_details <- function(page_url) {
  page <- read_html(page_url)
  
  # Extract startup details
  startup_data <- data.frame(
    StartUPName = page %>% html_node("div[class='starup_content'] h2") %>% html_text(trim = TRUE),
    Description = page %>% html_node("div[class='starup_content'] p") %>% html_text(trim = TRUE),
    Cohort = page %>% html_node(".cohart_number") %>% html_text(trim = TRUE),
    FounderName = page %>% html_nodes("h3") %>% html_text(trim = TRUE) %>% toString()
  )
  
  return(startup_data)
}

# Read startup URLs from the text file
startup_urls <- readLines("startup_urls.txt")

# List to store all startup data frames
all_startup_data <- list()

# Loop through each startup URL and extract details
for (startup_url in startup_urls) {
  startup_data <- get_startup_details(startup_url)
  all_startup_data[[startup_url]] <- startup_data
}

# Combine the list of data frames into a single data frame
all_startup_data <- do.call(rbind, all_startup_data)

# Specify the full path to the CSV file
csv_file_path <- "C:/Users/coded/Desktop/R Demo Projects/Web Scrapping NICF Website/startup_data_manual.csv"

# Save the startup data to a CSV file
write.csv(all_startup_data, file = csv_file_path, row.names = FALSE)
