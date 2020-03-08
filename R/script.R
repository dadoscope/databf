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

cat(paste(summdata$AnoMesReferencia,
          summdata$UF, 
          summdata$NomeMunicipioSIAFI, 
          summdata$CodigoMunicipioSIAFI, 
          summdata$meanValor, 
          summdata$sdValor, 
          summdata$nBeneficios, 
          summdata$quantile25, 
          summdata$quantile75, 
          summdata$quantile01, 
          summdata$quantile99, 
          summdata$minValor, 
          summdata$maxValor, sep=";"), 
    file="../data/aggregated_201409_BolsaFamilia_Pagamentos.csv",sep="\n")
