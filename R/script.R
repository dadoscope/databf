library(tidyverse)

bf_files <- list.files("../data")
all_data <- tibble()
for(f in bf_files){
   cat(f,sep="\n")
   all_data <- rbind(all_data, read.csv(paste0("../data/",f)))
}
nrow(all_data)
