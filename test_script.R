
# Uncomment to install 'sentitopics' package
#
# library(devtools)
# install_github('cpipal/sentitopics')
#
# You might have to install RTools before you can install the package if you are using R < 4.0.0
# RTools Windows: https://cran.r-project.org/bin/windows/Rtools/rtools40.html
# RTools Mac: https://cran.r-project.org/bin/macosx/tools/
#
# NB: If C++11 is not enabled, enable it by running 'Sys.setenv("PKG_CXXFLAGS"="-std=c++11")'


library(tidyverse)
library(quanteda)
library(tidytext)
library(foreach)
library(rngtools)
library(sentitopics)

dfm <- quanteda::data_corpus_inaugural %>% 
  quanteda::tokens(remove_numbers = TRUE, remove_punct = TRUE) %>%
  quanteda::dfm() %>% 
  quanteda::dfm_remove(quanteda::stopwords("english"))

tm <- dfm %>% quanteda::convert(to = "tm")

dict <- quanteda::data_dictionary_LSD2015[1:2]


# Run JST with quanteda dfm as input
set.seed(1899)
model <- sentitopics::jst(dfm, dict, numIters = 100)
pi <- model %>% sentitopics::get_parameter("pi")
head(pi)

# Run JST with tidytext tm as input
set.seed(1899)
model <- sentitopics::jst(tm, dict, numIters = 100)
pi <- model %>% sentitopics::get_parameter("pi")
head(pi)

# Run JST multiple times 
# (Set number of cores you want to use with 'ncores = ' if you want to)
res <- sentitopics::jstManyRuns(dfm, dict, numIters = 100, n = 10)
head(res)

# Run rJST with quanteda dfm as input
model <- sentitopics::jst_reversed(dfm, dict, numTopics = 30, numIters = 100)
words <- model %>% sentitopics::top20words()
head(words[,1:6])

# Run rJST with tidytext tm as input
model <- sentitopics::jst_reversed(tm, dict, numTopics = 30, numIters = 100)
words <- model %>% sentitopics::top20words()
head(words[,1:6])


