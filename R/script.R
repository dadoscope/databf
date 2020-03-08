library(tidyverse)

bf_files <- list.files("../data", pattern = "csv")
all_data <- tibble()
for(f in bf_files){
   cat(f,sep="\n")
   data <- read.csv(paste0("../data/",f), sep = ";", 
                    col.names = c("AnoMesReferencia",
                                  "AnoMesCompetencia",
                                  "UF",
                                  "CodigoMunicipioSIAFI",
                                  "NomeMunicipioSIAFI",
                                  "ValorBeneficio"),
                    dec = ",")
   summdata <- data %>% 
     group_by(AnoMesReferencia, 
              UF, 
              NomeMunicipioSIAFI, 
              CodigoMunicipioSIAFI) %>% 
     summarise(meanValor = mean(ValorBeneficio, na.rm = TRUE),
               sdValor = sd(ValorBeneficio, na.rm = TRUE),
               nBeneficios = n(),
               quantile25 = quantile(ValorBeneficio, probs=0.25, na.rm=TRUE),
               quantile75 = quantile(ValorBeneficio, probs=0.75, na.rm=TRUE),
               quantile01 = quantile(ValorBeneficio, probs=0.01, na.rm=TRUE),
               quantile99 = quantile(ValorBeneficio, probs=0.99, na.rm=TRUE),
               minValor = min(ValorBeneficio, na.rm=TRUE),
               maxValor = max(ValorBeneficio, na.rm=TRUE))
   write_csv2(summdata, path=paste0("../data/aggregated_",f), append = FALSE)
}

########### read all the data and plot some statistics

setwd("/Users/isiscosta/RScript/databf/R")
agg_files <- list.files("../data/", pattern = "aggregated")
all_data <- tibble()
for(f in agg_files){
  cat(f,sep="\n")
  data <- read.csv(paste0("../data/",f), sep = ";",
                   dec = ",")
  all_data <- rbind(all_data, data)
}

library(lubridate)
p1 <- all_data %>% 
  filter(UF %in% c("PE")) %>%
  mutate(AnoMesReferencia = ymd(paste(AnoMesReferencia,"01"))) %>%
  group_by(AnoMesReferencia, UF) %>%
  summarise(numero_de_beneficios = sum(nBeneficios, na.rm=TRUE)) %>%
  ggplot(aes(x = AnoMesReferencia, y = numero_de_beneficios, col = UF)) +
  geom_point(stat="identity") + geom_line() +
  ylim(0,2000000) +
  theme_bw()+
  labs(title = "Bolsa Família - Número de Benefícios concedidos")
png("../figures/beneficios_por_estado.png",width=3200,height=1800,res=300)
print(p1)
dev.off()
