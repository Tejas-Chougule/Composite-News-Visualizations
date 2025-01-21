# News Dataset Analysis and Visualization

This project involves cleaning, analyzing, and visualizing a news dataset to uncover trends, insights, and patterns. The analysis includes text processing, sentiment analysis, recategorization, and data visualization.

---

## Table of Contents
1. [Overview](#overview)
2. [Dataset](#dataset)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Features](#features)
6. [Visualizations](#visualizations)
7. [Output](#output)
8. [License](#license)

---

## Overview
This project processes and analyzes a news dataset by performing tasks such as:
- Cleaning and preprocessing text data.
- Tokenizing and removing stop words.
- Categorizing and grouping articles into meaningful categories.
- Generating word clouds, bar charts, line charts, heatmaps, and more.
- Highlighting country mentions and analyzing trends by category and author.

---

## Dataset
- **File Name**: `news.csv`
- **Columns Used**:
  - `headline`: Title of the news article.
  - `short_description`: Short summary of the news.
  - `authors`: Authors of the article.
  - `date`: Publication date.
  - `category`: Category of the article.

Place your dataset at the specified path in the script or update the path in the code.

---

## Installation
1. Clone the repository:
   ```bash
   git clone <https://github.com/Tejas-Chougule/Composite-News-Visualizations.git>
   ```
2. Install the required R packages:
   ```R
   install.packages("readr")
   install.packages("dplyr")
   install.packages("tidyr")
   install.packages("ggplot2")
   install.packages("viridis")
   install.packages("lubridate")
   install.packages("tidytext")
   install.packages("wordcloud")
   install.packages("RColorBrewer")
   install.packages("forcats")
   install.packages("rnaturalearth")
   install.packages("rnaturalearthdata")
   install.packages("sf")
   install.packages("wordcloud2")
   install.packages("htmlwidgets")
   ```
3. Load the libraries in your R script.

---

## Usage
1. Place your `news.csv` dataset in the specified path in the code.
2. Run the R script step-by-step to:
   - Clean and preprocess the dataset.
   - Visualize trends and relationships.
   - Generate outputs such as word clouds and country mentions.
3. Outputs will include:
   - Cleaned dataset.
   - Visualizations saved as images.
   - CSV file with country mentions and associated top words.

---

## Features
- **Data Cleaning**: Handles missing values, removes stop words, and processes text.
- **Recategorization**: Groups categories into broader, meaningful themes.
- **Visualization**:
  - Bar charts showing category distributions.
  - Line charts displaying trends over time.
  - Heatmaps of author contributions by category.
  - Word clouds of the most frequent words.
  - A heatmap of country mentions overlaid on a world map.
- **Export Outputs**: Saves processed data and visualizations.

---

## Visualizations
1. **Bar Chart**: Articles per grouped category.
2. **Line Chart**: Trends over time for the top categories.
3. **Heatmap**: Author contributions by category.
4. **World Map Heatmap**: Country mentions in the news dataset.
5. **Word Cloud**: Top words in news articles.

---

## Output
- `heatmap.png`: Heatmap of country mentions overlaid on a world map.
- `country_mentions_with_top_words.csv`: Detailed analysis of country mentions and associated top words.
- Word clouds visualized using `wordcloud2`.

---

