---
  title: "Week 10: introduction to Sentiment Analysis "
author: "Jose Fuentes"
date: "2024-11-11"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Going through Sentiment analysis

This study looks at the feelings in Edgar Allan Poe's writings using computer-based text analysis. Known for his dark and mysterious style, Poe's works are perfect for sentiment analysis. The goal is to break down, clean, and analyze his texts with the NRC word-emotion lexicon to find emotional patterns. Using R's tidyverse, tidytext, and gutenbergr packages, the analysis finds how often feelings like joy, fear, anger, and sadness appear, shedding light on the emotions in Poe's literary work.

The data for this analysis was taken from Project Gutenberg using the gutenbergr package. Two works by Edgar Allan Poe, identified by their Gutenberg IDs (2147 and 25525), were downloaded. The text was then split into individual words using the tidytext package's unnest_tokens() function. Common words like "the" and "and" that don't affect sentiment analysis were removed using a predefined list. To analyze emotional content, the cleaned text was matched with the NRC word-emotion lexicon, which categorizes words into emotions like fear, anger, and joy. The data was then summarized to count how often each emotion appeared, forming the basis for visualizations and further insights into Poe's writing.

```{r}
#install.packages("xfun")

# Install required packages if not already installed
if (!requireNamespace("textdata", quietly = TRUE)) {
  install.packages("textdata")
}

# Load libraries
library(tidytext)
library(tidyverse)
library(gutenbergr)
library(wordcloud)
library(textdata)

# Set a specific Project Gutenberg mirror
options(gutenberg_mirror = "http://mirror.csclub.uwaterloo.ca/gutenberg/")

# Download corpus (Edgar Allan Poe)
book_ids <- c(2147, 25525)

poe_books <- book_ids %>%
  purrr::map_df(~ gutenberg_download(.x, verbose = FALSE))

# Proceed with text processing and analysis
tidy_poe <- poe_books %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

nrc_sentiments <- tidy_poe %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment, sort = TRUE)

```

## Including Plots

```{r plots}
#NRC Sentiment Lexicon
nrc_sentiments %>%
  ggplot(aes(x = sentiment, y = n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  labs(title = "NRC Sentiments in Edgar Allan Poe's Works",
       x = "Sentiment", y = "Frequency") +
  theme_minimal()

#Incorporating other sentiment lexicon
# Using Bing Lexicon
bing_sentiments <- tidy_poe %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment, sort = TRUE)

# Plot Bing Sentiments
bing_sentiments %>%
  ggplot(aes(x = sentiment, y = n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Bing Sentiments in Edgar Allan Poe's Works",
       x = "Sentiment", y = "Frequency") +
  theme_minimal()
```

#Comparing sentiment lexicons: 
The NRC sentiment analysis provided a detailed breakdown of emotions in Edgar Allan Poe's works, identifying categories such as anger, anticipation, fear, joy, sadness, surprise, trust, and both positive and negative sentiments, with a notable prevalence of positive sentiments and strong associations with fear and anticipation. In contrast, the Bing lexicon offered a simpler binary classification, showing more negative words than positive, which aligns with Poe's dark themes but lacks the depth of nuanced emotional categories provided by the NRC lexicon.

#Conclusion
The analysis reveals that Edgar Allan Poe's works evoke a wide range of emotions, with the NRC lexicon highlighting significant themes of fear, sadness, and anticipation. At the same time, the Bing lexicon indicates a prevailing negative sentiment, aligning with the dark and eerie nature of his literature. Together, these lexicons offer complementary perspectives, with the NRC providing detailed emotional depth and the Bing offering clear polarity. This combination enhances our understanding of the emotional nuances in Poe's writings.