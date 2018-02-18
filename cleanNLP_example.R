####CleanNLP

library(cleanNLP)
library(tokenizers)
library(coreNLP)
init_tokenizers(locale = "sv")

texts <- as.character(df$news[-1])

di <- run_annotators(texts, as_strings = TRUE)
tokens <- get_combine(di)

tokens %>% group_by(id) %>%
  summarise(count = length(word)) %>%
  summarise(mean = mean(count),
            sd = sd(count),
            median = median(count))

#coreNLP

init_coreNLP(language = "en")
download_core_nlp() # download jar files --> language files

anno <- run_annotators(texts, as_strings = TRUE)
nlp <- get_combine(anno)


