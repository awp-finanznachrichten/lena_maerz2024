#library(tidyverse)
#library(DatawRappr)

#data

ocde <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/OECD_Mindeststeuer_all_data.csv")

climat <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Klima_Gesetz_all_data.csv")  

covid <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Covid_Gesetz_all_data.csv")

top_flop <- function(obj,order,langage) {
  if(order == "top")  {data_top <- obj %>%
    mutate(Nein_Stimmen_In_Prozent = 100-Ja_Stimmen_In_Prozent) %>%
    arrange(desc(Ja_Stimmen_In_Prozent)) %>%
    slice(1:50)
  }
  if(order == "flop") {data_flop <- obj %>%
    mutate(Nein_Stimmen_In_Prozent = 100-Ja_Stimmen_In_Prozent) %>%
    arrange(Ja_Stimmen_In_Prozent) %>%
    slice(1:50)
  }
  if(langage == "de" & order == "top") {output <- data_top %>%
    select(Gemeinde_KT_d,Ja_Stimmen_In_Prozent) %>%
    rename(Gemeinde = Gemeinde_KT_d,
           "Ja in Prozent" = Ja_Stimmen_In_Prozent)
  }
  if(langage == "de" & order == "flop") {output <- data_flop %>%
    select(Gemeinde_KT_d,Nein_Stimmen_In_Prozent) %>%
    rename(Gemeinde = Gemeinde_KT_d,
           "Nein in Prozent" = Nein_Stimmen_In_Prozent)
  }
  if(langage == "fr" & order == "top") {output <- data_top %>%
    select(Gemeinde_KT_f,Ja_Stimmen_In_Prozent) %>%
    rename(Commune = Gemeinde_KT_f,
           "Pourcentage de oui" = Ja_Stimmen_In_Prozent)
  }
  if(langage == "fr" & order == "flop") {output <- data_flop %>%
    select(Gemeinde_KT_f,Nein_Stimmen_In_Prozent) %>%
    rename(Commune = Gemeinde_KT_f,
           "Pourcentage de non" = Nein_Stimmen_In_Prozent)
  }
  if(langage == "it" & order == "top") {output <- data_top %>%
    select(Gemeinde_KT_i,Ja_Stimmen_In_Prozent) %>%
    rename(Comune = Gemeinde_KT_i,
           "Percentuale di sì" = Ja_Stimmen_In_Prozent)
  }
  if(langage == "it" & order == "flop") {output <- data_flop %>%
    select(Gemeinde_KT_i,Nein_Stimmen_In_Prozent) %>%
    rename(Comune = Gemeinde_KT_i,
           "Percentuale di no" = Nein_Stimmen_In_Prozent)
  }
  return(output)
}

