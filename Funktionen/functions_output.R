get_output_gemeinden <- function(dta,
                                 language) {

  if (language == "de") {
  output_dw <- dta %>%
    select(Gemeinde_Nr,Gemeinde_color,Ja_Stimmen_In_Prozent,Nein_Stimmen_In_Prozent,Gemeinde_KT_d,Text_d) %>%
    rename(ID = Gemeinde_Nr,
      Gemeinde_de = Gemeinde_KT_d,
           Text_de = Text_d)
  }
  if (language == "fr") {
    output_dw <- dta %>%
      select(Gemeinde_Nr,Gemeinde_color,Ja_Stimmen_In_Prozent,Nein_Stimmen_In_Prozent,Gemeinde_KT_f,Text_f) %>%
      rename(ID = Gemeinde_Nr,
        Gemeinde_fr = Gemeinde_KT_f,
             Text_fr = Text_f)
  }
  if (language == "it") {
    output_dw <- dta %>%
      select(Gemeinde_Nr,Gemeinde_color,Ja_Stimmen_In_Prozent,Nein_Stimmen_In_Prozent,Gemeinde_KT_i,Text_i) %>%
      rename(ID = Gemeinde_Nr,
        Gemeinde_it = Gemeinde_KT_i,
             Text_it = Text_i)
  }
  
  
  #Runden
  output_dw$Ja_Stimmen_In_Prozent <- round(output_dw$Ja_Stimmen_In_Prozent,1)
  output_dw$Nein_Stimmen_In_Prozent <- round(output_dw$Nein_Stimmen_In_Prozent,1)
  output_dw$Gemeinde_color <- round(output_dw$Gemeinde_color,1)
  
return(output_dw)  
}  

get_output_kantone <- function(dta) {

output_dw_kantone <- dta %>%
    select(Kantons_Nr,Kanton_d,Kanton_f,Kanton_i,Ja_Stimmen_In_Prozent_Kanton) %>%
    mutate(Nein_Stimmen_In_Prozent_Kanton = round(100-Ja_Stimmen_In_Prozent_Kanton,1),
           Ja_Stimmen_In_Prozent_Kanton = round(Ja_Stimmen_In_Prozent_Kanton,1),
           Kanton_color = 50,
           Gemeinden_overall = 0,
           Gemeinden_counted = 0,
           Legende = NA) %>%
    unique()

for (y in 1:nrow(output_dw_kantone)) {
  
  #Gemeinden zählen
  output_dw_kantone$Gemeinden_overall[y] <- nrow(dta[dta$Kantons_Nr == output_dw_kantone$Kantons_Nr[y],])
  output_dw_kantone$Gemeinden_counted[y] <- nrow(dta[dta$Kantons_Nr == output_dw_kantone$Kantons_Nr[y] & dta$Gebiet_Ausgezaehlt == TRUE,])
  
  if (output_dw_kantone$Gemeinden_counted[y] == 0) { 
    
    output_dw_kantone$Ja_Stimmen_In_Prozent_Kanton[y] <- 0
    output_dw_kantone$Nein_Stimmen_In_Prozent_Kanton[y] <- 0
    output_dw_kantone$Kanton_color[y] <- 50
    output_dw_kantone$Legende[y] <- paste0(output_dw_kantone$Gemeinden_counted[y],"/",output_dw_kantone$Gemeinden_overall[y])
    
  } else if (output_dw_kantone$Gemeinden_counted[y] < output_dw_kantone$Gemeinden_overall[y]) {
    
    output_dw_kantone$Legende[y] <- paste0(output_dw_kantone$Gemeinden_counted[y],"/",output_dw_kantone$Gemeinden_overall[y])
    
    if (output_dw_kantone$Ja_Stimmen_In_Prozent_Kanton[y] > 50) {
      
      output_dw_kantone$Kanton_color[y] <- 100
      
    } else {
      
      output_dw_kantone$Kanton_color[y] <- 0
      
    }  
    
  } else {
    
    output_dw_kantone$Kanton_color[y] <- output_dw_kantone$Ja_Stimmen_In_Prozent_Kanton[y]
    
    #Log-Entry
    cat(paste0(output_dw_kantone$Kanton_d[y],", "),file="Logfiles/log_file.txt",append = TRUE)

  }  
  
}
  
return(output_dw_kantone)


}
