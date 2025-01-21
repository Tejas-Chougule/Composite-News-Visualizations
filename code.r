install.packages("readr")
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot")
install.packages("viridis")
library(ggplot2)
library(tidyr)
library(dplyr)
library(readr)
library(tidytext)
library(viridis)
library(lubridate)
library(tidytext)
library(wordcloud)
library(dplyr)
library(RColorBrewer)
library(forcats)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(viridis)
library(wordcloud2)
library(htmlwidgets)


news <- read_csv("C:/Users/tejas/Desktop/INTRO TO DATA SCIENCE/Dataset/news.csv")

# Check the first few rows
head(news)
# Check the structure of the dataset
str(news)
# Converting the 'date' column to Date format
news <- news %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))

# Removing rows with missing values in critical columns
news <- news %>%
  filter(!is.na(headline), !is.na(category))

# Converting all text in 'headline' to lowercase
news <- news %>%
  mutate(headline = tolower(headline))
news <- news %>%
  drop_na(short_description, authors)

# Check for missing values after cleaning
colSums(is.na(news))

# Preview the cleaned dataset
head(news)

headlines_tokens <- news %>%
  unnest_tokens(word, headline) %>%
  anti_join(stop_words)  # Remove stop words

#Checking the distribution of categories
news %>%
  count(category) %>%
  arrange(desc(n))

news %>%
  mutate(year = lubridate::year(date)) %>%
  count(year, category) %>%
  ggplot(aes(x = year, y = n, color = category)) +
  geom_line()

news <- news %>%
  mutate(category = tolower(category))
category_count <- news %>%
  count(category, sort = TRUE)
total_articles <- sum(category_count$n)

# Calculating the percentage of articles in each category
category_count <- category_count %>%
  mutate(Percentage = (n / total_articles) * 100)

# Identifying categories with more than 5% and less than 1% of total articles
categories_above_5 <- category_count %>% filter(Percentage > 5) %>% pull(category)
categories_below_1 <- category_count %>% filter(Percentage < 1) %>% pull(category)

# Defining meaningful groups for recategorization
group_mapping <- c(
  "parenting" = "Health & Family",
  "healthy living" = "Health & Family",
  "queer voices" = "Social Justice",
  "food & drink" = "Lifestyle",
  "business" = "Economy & Business",
  "comedy" = "Entertainment & Media",
  "sports" = "Sports",
  "black voices" = "Social Justice",
  "home & living" = "Lifestyle",
  "parents" = "Health & Family",
  "the worldpost" = "World News",
  "weddings" = "Lifestyle",
  "women" = "Social Justice",
  "crime" = "Crime & Justice",
  "impact" = "Social Impact",
  "divorce" = "Lifestyle",
  "world news" = "World News",
  "media" = "Entertainment & Media",
  "weird news" = "Entertainment & Media",
  "green" = "Environment & Science",
  "worldpost" = "World News",
  "religion" = "Culture & Religion",
  "style" = "Arts & Culture",
  "science" = "Environment & Science",
  "tech" = "Technology",
  "taste" = "Lifestyle"
)

# Applying the group mapping to create a new grouped category column
news <- news %>%
  mutate(category_grouped = case_when(
    category %in% names(group_mapping) ~ group_mapping[category],
    category %in% categories_above_5 ~ category,
    category %in% categories_below_1 ~ "Remove",
    TRUE ~ "Other"
  )) %>%
  filter(category_grouped != "Remove")

category_grouped_count <- news %>%
  count(category_grouped, sort = TRUE)
print(category_grouped_count)
category_grouped_count <- category_grouped_count %>%
  mutate(Percentage = round((n / sum(n)) * 100, 1))


# Grouping categories with percentages
ggplot(category_grouped_count, aes(x = reorder(category_grouped, -n), y = n, fill = category_grouped)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(n, " (", Percentage, "%)")), hjust = -0.1, size = 3) + # Add count and percentage labels
  coord_flip() + # Flip for readability
  scale_fill_viridis_d(option = "plasma") + # Better color palette
  labs(
    title = "Number of Articles per Grouped Category",
    subtitle = "Total 209,527 news articles",
    x = "Grouped Category",
    y = "Number of Articles",
    fill = "Category"
  ) +
  theme_minimal() +
  theme(plot.subtitle = element_text(size = 10, face = "italic"))

top_categories <- category_trends %>%
  group_by(category_grouped) %>%
  summarise(total_articles = sum(n)) %>%
  arrange(desc(total_articles)) %>%
  slice(1:5) %>%
  pull(category_grouped)

# Filtering the data for top categories
category_trends_top <- category_trends %>%
  filter(category_grouped %in% top_categories)

ggplot(category_trends_top, aes(x = year, y = n, color = category_grouped)) +
  geom_line(linewidth = 1) + 
  geom_point(size = 2) +
  labs(
    title = "Article Trends Over Time (Top 5 Categories)",
    subtitle = "Top grouped categories over the years",
    x = "Year",
    y = "Number of Articles",
    color = "Category"
  ) +
  annotate("text", x = 2017, y = max(category_trends$n), label = "Peak Year", size = 4, color = "black") +  
  theme_minimal() +
  scale_color_viridis_d(option = "turbo") +
  theme(
    plot.subtitle = element_text(size = 10, face = "italic"),
    legend.position = "bottom"
  )

author_category_data <- news %>%
  filter(!is.na(authors) & !is.na(category_grouped)) %>%  # Remove missing data
  count(authors, category_grouped, sort = TRUE)  # Count articles per author-category pair

# Filtering the data for top 10 authors
top_authors <- author_category_data %>%
  group_by(authors) %>%
  summarise(total_articles = sum(n)) %>%
  arrange(desc(total_articles)) %>%
  slice(1:10) %>%
  pull(authors)

author_category_top <- author_category_data %>%
  filter(authors %in% top_authors)

author_category_top <- author_category_top %>%
  mutate(authors = fct_reorder(authors, n, .fun = sum))

# Heatmap to showing the relationship between authors and categories
ggplot(author_category_top, aes(x = category_grouped, y = authors, fill = n)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "turbo") +
  labs(
    title = "Author Contributions by Grouped Category",
    subtitle = "Heatmap showing article contributions by top authors across categories",
    x = "Grouped Category",
    y = "Authors",
    fill = "Number of Articles"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10),
    strip.text = element_text(face = "bold"),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 10, face = "italic")
  )

# Combining headline and short_description for better context
news <- news %>%
  mutate(combined_text = paste(headline, short_description, sep = " "))

# Listing countries
country_list <- unique(rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")$name)

# Extracting country mentions
news <- news %>%
  rowwise() %>%
  mutate(country = {
    matched_country <- NA
    for (country in country_list) {
      if (grepl(country, combined_text, ignore.case = TRUE)) {
        matched_country <- country
        break
      }
    }
    matched_country
  })

country_mentions <- news %>%
  filter(!is.na(country)) %>%
  group_by(country) %>%
  summarise(mentions = n(), .groups = "drop")

# Loading world map data
world_map <- ne_countries(scale = "medium", returnclass = "sf")

world_data <- world_map %>%
  left_join(country_mentions, by = c("name" = "country"))

# Highlighting top countries
top_countries <- country_mentions %>%
  filter(mentions > quantile(mentions, 0.90))  # Top 10% by mentions

# Heatmap on the top of World map
heatmap_map <- ggplot(world_data) +
  geom_sf(aes(fill = mentions), color = "white", size = 0.1) +  # Fill by mentions
  geom_sf_text(data = world_data %>% filter(name %in% top_countries$country),
               aes(label = name), size = 3, color = "black") +  # Label top countries
  scale_fill_viridis_c(option = "plasma", na.value = "gray90", name = "Mentions Count") +  # Improved color scale
  labs(
    title = "Heatmap of Country Mentions",
    subtitle = "Countries Mentioned in News Headlines",
    x = NULL,
    y = NULL
  ) +
  theme_minimal() +
  theme(
    legend.position = "right",  # Place legend on the side
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),  # Bold and center title
    plot.subtitle = element_text(hjust = 0.5, size = 12, face = "italic"),  # Italic subtitle
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    legend.title = element_text(size = 10),  # Adjust legend font
    legend.text = element_text(size = 8)
  )
output_path <- "heatmap.png"
ggsave(output_path, heatmap_map, width = 12, height = 8)


news <- news %>%
  rowwise() %>%
  mutate(country = extract_country_mentions(combined_text, countries_list))

# Tokenize the text and filter by country
tokenized_news <- news %>%
  filter(!is.na(country)) %>%
  unnest_tokens(word, combined_text) %>%
  filter(!word %in% stop_words$word)

# Counting word frequencies for each country
word_counts <- tokenized_news %>%
  group_by(country, word) %>%
  summarise(word_count = n(), .groups = "drop") %>%
  arrange(country, desc(word_count))

# Extracting top 5 words for each country
top_words <- word_counts %>%
  group_by(country) %>%
  slice_max(word_count, n = 5) %>%
  summarise(top_words = paste(word, collapse = ", "), .groups = "drop")

# Counting mentions per country
country_mentions <- news %>%
  filter(!is.na(country)) %>%
  group_by(country) %>%
  summarise(Mentions = n(), .groups = "drop") %>%
  arrange(desc(Mentions))

# percentage 
total_mentions <- sum(country_mentions$Mentions)
country_mentions <- country_mentions %>%
  mutate(Percentage = round((Mentions / total_mentions) * 100, 2)) %>%
  arrange(desc(Mentions))

# Adding ranks
country_mentions <- country_mentions %>%
  mutate(Rank = row_number())

# Joining with top words
country_mentions <- country_mentions %>%
  left_join(top_words, by = "country")
country_mentions <- country_mentions %>%
  rename(
    "Country" = country,
    "Mentions" = Mentions,
    "Percentage (%)" = Percentage,
    "Rank" = Rank,
    "Top Words come up with the country" = top_words
  )
print(country_mentions)
write_csv(country_mentions, "country_mentions_with_top_words.csv")

# Custom stop words
custom_stopwords <- c("day", "week", "time", "photo", "video", "get", "people", "says", 
                      "new", "just", "will", "now", "like", "make", "back", "love", 
                      "year", "life", "women", "one", "also", "first", "two","photos","5","10","7","3","6","12","20","1","7","9")

# Tokenizing
tokenized_words <- news %>%
  unnest_tokens(word, combined_text) %>%
  anti_join(stop_words, by = "word") %>%           
  filter(!word %in% custom_stopwords) %>%          
  count(word, sort = TRUE)                         

top_words <- tokenized_words %>%
  slice_max(n, n = 100)

wordcloud2(data = top_words, size = 0.7, color = "random-light", backgroundColor = "black")

