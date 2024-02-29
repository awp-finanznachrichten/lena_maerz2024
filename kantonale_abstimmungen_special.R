completed_votes <- read_rds("completed_votes.RDS")

for (s in 1:length(kantonal_short_special) ) {
#i <- k
  if (sum(grepl(kantonal_short_special[s],completed_votes) == 0)) {
  cat(paste0("\nErmittle Daten für folgende Vorlage: ",kantonal_short_special[s],"\n"))
  
  results <- get_results_kantonal(json_data_kantone,
                                  kantonal_number_special[s],
                                  kantonal_add_special[s])
  
  results_kantonal_special_initiative <- get_results_kantonal(json_data_kantone,
                                                   kantonal_number_special[s],
                                                   kantonal_add_special[s],
                                                   level="kantonal")
  
  #Daten anpassen Gemeinden
  results <- treat_gemeinden(results)
  results <- format_data_g(results)
 

  #Wie viele Gemeinden sind ausgezählt?
  cat(paste0(sum(results$Gebiet_Ausgezaehlt)," Gemeinden sind ausgezählt.\n"))
  
  #Neue Variablen
  results <- results %>%
    mutate(Ja_Nein = NA,
           Oui_Non = NA,
           Nein_Stimmen_In_Prozent = NA,
           Unentschieden = NA,
           Einstimmig_Ja = NA,
           Einstimmig_Nein = NA,
           kleine_Gemeinde = NA,
           Highest_Yes_Kant = FALSE,
           Highest_No_Kant = FALSE,
           Storyboard = NA,
           Text_d = "Die Resultate dieser Gemeinde sind noch nicht bekannt.",
           Text_f = "Les résultats ne sont pas encore connus dans cette commune.",
           Text_i = "I resultati di questa comune non sono ancora noti.")
  
  hist_check <- FALSE
  
  #Gegenvorschlag hinzufügen
  results_gegenvorschlag <- get_results_kantonal(json_data_kantone,
                                                 kantonal_number_special[s],
                                                 ifelse(kantonal_short_special[s] == "VS_Verfassung",
                                                        kantonal_add_special[s]+2,
                                                        kantonal_add_special[s]+1))
                                                 
  results_kantonal_special_gegenvorschlag <- get_results_kantonal(json_data_kantone,
                                                              kantonal_number_special[s],
                                                              ifelse(kantonal_short_special[s] == "VS_Verfassung",
                                                                     kantonal_add_special[s]+2,
                                                                     kantonal_add_special[s]+1),
                                                              level="kantonal")
  

  results_gegenvorschlag <- results_gegenvorschlag[,c(3:6,11)]
  results_gegenvorschlag$neinStimmenInProzent <- 100-results_gegenvorschlag$jaStimmenInProzent
  
  colnames(results_gegenvorschlag) <- c("Gebiet_Ausgezaehlt_Gegenvorschlag","Ja_Prozent_Gegenvorschlag","Ja_Absolut_Gegenvorschlag","Nein_Absolut_Gegenvorschlag",
                                        "Gemeinde_Nr","Nein_Prozent_Gegenvorschlag")

  results <- merge(results,results_gegenvorschlag)
  

  #Stichentscheid hinzufügen
  results_stichentscheid <- get_results_kantonal(json_data_kantone,
                                                 kantonal_number_special[s],
                                                 ifelse(kantonal_short_special[s] == "VS_Verfassung",
                                                        kantonal_add_special[s]+3,
                                                        kantonal_add_special[s]+2))
  
  results_kantonal_special_stichentscheid <- get_results_kantonal(json_data_kantone,
                                                                  kantonal_number_special[s],
                                                                  ifelse(kantonal_short_special[s] == "VS_Verfassung",
                                                                         kantonal_add_special[s]+3,
                                                                         kantonal_add_special[s]+2),
                                                                  level="kantonal")
  
  results_stichentscheid  <- results_stichentscheid[,c(3:4,11)]
  results_stichentscheid$neinStimmenInProzent <- 100-results_stichentscheid$jaStimmenInProzent
  
  colnames(results_stichentscheid) <- c("Gebiet_Ausgezaehlt_Stichentscheid","Stichentscheid_Zustimmung_Hauptvorlage","Gemeinde_Nr","Stichentscheid_Zustimmung_Gegenvorschlag")
  
  results <- merge(results,results_stichentscheid)

  #Ausgezählte Gemeinden auswählen
  results_notavailable <- results[results$Gebiet_Ausgezaehlt == FALSE |
                                    results$Gebiet_Ausgezaehlt_Gegenvorschlag == FALSE |
                                    results$Gebiet_Ausgezaehlt_Stichentscheid == FALSE,]
  
  results <- results[results$Gebiet_Ausgezaehlt == TRUE &
                       results$Gebiet_Ausgezaehlt_Gegenvorschlag == TRUE &
                       results$Gebiet_Ausgezaehlt_Stichentscheid == TRUE,]
  
  

  #Sind schon Daten vorhanden?
  if (nrow(results) > 0) {
    
    #Daten anpassen
    results <- augment_raw_data(results)
    
    #Texte generieren
    results <- special_intro(results)
    
    #Textvorlagen laden
    Textbausteine <- as.data.frame(read_excel(paste0("Data/Textbausteine_LENA_",abstimmung_date,".xlsx"), 
                                              sheet = kantonal_short_special[s]))
    cat("Textvorlagen geladen\n\n")


    #Texte einfügen
    results <- build_texts(results)
    
    #Variablen ersetzen 
    results <- replace_variables_special(results)
    
    ###Texte anpassen und optimieren
    results <- excuse_my_french(results)
    
  }
  ###Ausgezählte und nicht ausgezählte Gemeinden wieder zusammenführen -> Immer gleiches Format für Datawrapper
  if (nrow(results_notavailable) > 0) {
    
    results_notavailable$Ja_Stimmen_In_Prozent <- 0
    results_notavailable$Nein_Stimmen_In_Prozent <- 0
    results_notavailable$Gemeinde_color <- 50
    
    results <- rbind(results,results_notavailable) %>%
      arrange(Gemeinde_Nr)
    
  }
  
#Texte speichern
#library(xlsx)
#write.xlsx(results,paste0(kantonal_short_special[s],"_texte.xlsx"))
  
  ###Output generieren für Datawrapper
  #Output Abstimmungen Gemeinde
  output_dw_de <- get_output_gemeinden(results,language = "de")
  output_dw_fr <- get_output_gemeinden(results,language = "fr")
  output_dw_it <- get_output_gemeinden(results,language = "it")
  
  #Output speichern
  write.csv(output_dw_de,paste0("Output_Cantons/",kantonal_short_special[s],"_dw_de.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(output_dw_fr,paste0("Output_Cantons/",kantonal_short_special[s],"_dw_fr.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(output_dw_it,paste0("Output_Cantons/",kantonal_short_special[s],"_dw_it.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  
  cat(paste0("\nGenerated output for Vorlage ",kantonal_short_special[s],"\n"))
  
  
  ###
  count_non_gemeinden <- output_dw_de[output_dw_de$Nein_Stimmen_In_Prozent>50,]
  
  count_yes_gemeinden <- output_dw_de[output_dw_de$Ja_Stimmen_In_Prozent>50,]
  
  count_tie_gemeinden <- output_dw_de[output_dw_de$Ja_Stimmen_In_Prozent == 50,]
  
  print(paste0("Nein-Stimmen: ",nrow(count_non_gemeinden),"; Ja-Stimmen: ",nrow(count_yes_gemeinden),
               "; Unentschieden: ",nrow(count_tie_gemeinden)))
  
  #Datawrapper-Karten aktualisieren
  undertitel_de <- "Es sind noch keine Gemeinden ausgezählt."
  undertitel_fr <- "Aucun résultat n'est encore connu."
  undertitel_it <- "Nessun risultato è ancora noto."
  
  hold <- FALSE
  if (hold == FALSE) {
    if (is.na(results_kantonal_special_initiative) == FALSE) {
      
      undertitel_de <- paste0("Die brieflichen Stimmen sind ausgezählt.<br>Stand Initiative: <b>",
                              round(results_kantonal_special_initiative,1)," %</b> Ja, <b>",
                              round(100-results_kantonal_special_initiative,1)," %</b> Nein<br>",
                              "Stand Gegenvorschlag: <b>",
                              round(results_kantonal_special_gegenvorschlag,1)," %</b> Ja, <b>",
                              round(100-results_kantonal_special_gegenvorschlag,1)," %</b> Nein<br>",
                              "Stand Stichentscheid: <b>",
                              round(results_kantonal_special_stichentscheid,1)," %</b> Initiative, <b>",
                              round(100-results_kantonal_special_stichentscheid,1)," %</b> Gegenvorschlag"
      )
      
      undertitel_fr <- paste0("Les votes par correspondance ont été dépouillés.<br>Etat initiative: <b>",
                              round(results_kantonal_special_initiative,1)," %</b> oui, <b>",
                              round(100-results_kantonal_special_initiative,1)," %</b> non<br>",
                              "Etat contre-proposition: <b>",
                              round(results_kantonal_special_gegenvorschlag,1)," %</b> oui, <b>",
                              round(100-results_kantonal_special_gegenvorschlag,1)," %</b> non<br>",
                              "Etat question subsidiaire: <b>",
                              round(results_kantonal_special_stichentscheid,1)," %</b> initiative, <b>",
                              round(100-results_kantonal_special_stichentscheid,1)," %</b> contre-proposition"
      )
    
    if (sum(results$Gebiet_Ausgezaehlt) > 0 ) {
      undertitel_de <- paste0("Es sind <b>",sum(results$Gebiet_Ausgezaehlt),"</b> von <b>",nrow(results),
                              "</b> Gemeinden ausgezählt.<br>Stand Initiative: <b>",
                              round(results_kantonal_special_initiative,1)," %</b> Ja, <b>",
                              round(100-results_kantonal_special_initiative,1)," %</b> Nein<br>",
                              "Stand Gegenvorschlag: <b>",
                              round(results_kantonal_special_gegenvorschlag,1)," %</b> Ja, <b>",
                              round(100-results_kantonal_special_gegenvorschlag,1)," %</b> Nein<br>",
                              "Stand Stichentscheid: <b>",
                              round(results_kantonal_special_stichentscheid,1)," %</b> Initiative, <b>",
                              round(100-results_kantonal_special_stichentscheid,1)," %</b> Gegenvorschlag"
                              )
      
      undertitel_fr <- paste0("Les résultats de <b>",sum(results$Gebiet_Ausgezaehlt),"</b> des <b>",nrow(results),
                              "</b> communes sont connus.<br>Etat initiative: <b>",
                              round(results_kantonal_special_initiative,1)," %</b> oui, <b>",
                              round(100-results_kantonal_special_initiative,1)," %</b> non<br>",
                              "Etat contre-proposition: <b>",
                              round(results_kantonal_special_gegenvorschlag,1)," %</b> oui, <b>",
                              round(100-results_kantonal_special_gegenvorschlag,1)," %</b> non<br>",
                              "Etat question subsidiaire: <b>",
                              round(results_kantonal_special_stichentscheid,1)," %</b> initiative, <b>",
                              round(100-results_kantonal_special_stichentscheid,1)," %</b> contre-proposition"
      )
    }
    if (kantonal_short_special[s] == "VS_Verfassung") {
      undertitel_de <- gsub("Initiative","Entwurf",undertitel_de)
      undertitel_de <- gsub("Gegenvorschlag","Variante",undertitel_de)
      undertitel_fr <- gsub("initiative","project",undertitel_fr)
      undertitel_fr <- gsub("contre[-]proposition","variante",undertitel_fr)
    }
      if (sum(results$Gebiet_Ausgezaehlt) == nrow(results)) {
        completed_votes <- c(completed_votes,kantonal_short_special[s]) 
        write_rds(completed_votes,"completed_votes.RDS")
        print(paste0("Alle Daten der Abstimmung ",kantonal_short_special[s]," vorhanden"))
      }
    }    

    
    datawrapper_codes_vorlage <- datawrapper_codes_kantonal[datawrapper_codes_kantonal$Vorlage == kantonal_short_special[s],]

    #Karten Gemeinden
    for (r in 1:nrow(datawrapper_codes_vorlage)) {
      if (datawrapper_codes_vorlage$Sprache[r] == "de-DE") {
        dw_edit_chart(datawrapper_codes_vorlage[r,5],intro=undertitel_de,annotate=paste0("Letzte Aktualisierung: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
        dw_publish_chart(datawrapper_codes_vorlage[r,5])
      } else {
        dw_edit_chart(datawrapper_codes_vorlage[r,5],intro=undertitel_fr,annotate=paste0("dernière mise à jour: ",format(Sys.time(),"%d.%m.%Y %Hh%M")))
        dw_publish_chart(datawrapper_codes_vorlage[r,5])
      }
    }
    
  }  
  }
}

