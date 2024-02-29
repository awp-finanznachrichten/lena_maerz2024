kantone_list <- json_data_kantone[["kantone"]]
completed_cantons <- read_rds("completed_cantons.RDS")
#completed_cantons <- c("") 
#write_rds(completed_cantons,"completed_cantons.RDS")

for (k in 1:nrow(kantone_list)) {

if (sum(grepl(kantone_list$geoLevelname[k],completed_cantons)) == 0) {
  
data_overview <- data.frame(50,50,"Abstimmung_de","Abstimmung_fr","Abstimmung_it")
colnames(data_overview) <- c("Ja","Nein","Abstimmung_de","Abstimmung_fr","Abstimmung_it")  
vorlagen <- kantone_list$vorlagen[[k]]

check_counted <- c()

for (i in 1:nrow(vorlagen)) {
check_counted[i] <- FALSE
results <- get_results_kantonal(json_data_kantone,
                                  k,
                                  i)

results <- treat_gemeinden(results)
results <- format_data_g(results)

Ja_Stimmen_Kanton <- get_results_kantonal(json_data_kantone,
                                          k,
                                          i,
                                          "kantonal")
 
#Titel aus Spreadsheet
titel_all <- Vorlagen_Titel %>%
  filter(Kanton == kantone_list$geoLevelname[k],
         Vorlage_ID == vorlagen$vorlagenId[i])

#Eintrag für Uebersicht
uebersicht_text_de <- paste0("<b>",titel_all$Vorlage_d[1],"</b><br>",
                             "Es sind noch keine Gemeinden ausgezählt.")

uebersicht_text_fr <- paste0("<b>",titel_all$Vorlage_f[1],"</b><br>",
                             "Aucun résultat n'est encore connu.")

uebersicht_text_it <- paste0("<b>",titel_all$Vorlage_i[1],"</b><br>",
                             "Nessun risultato è ancora noto.")
Ja_Anteil <- 50
Nein_Anteil <- 50

if (is.na(Ja_Stimmen_Kanton) == FALSE) {
  uebersicht_text_de <- paste0("<b>",titel_all$Vorlage_d[1],"</b><br>",
                               "Die brieflichen Stimmen sind ausgezählt.")
  
  uebersicht_text_fr <- paste0("<b>",titel_all$Vorlage_f[1],"</b><br>",
                               "Les votes par correspondance ont été dépouillés.")
  
  uebersicht_text_it <- paste0("<b>",titel_all$Vorlage_i[1],"</b><br>",
                               "I voti per corrispondenza sono stati scrutinati.")
if (sum(results$Gebiet_Ausgezaehlt) > 0 ) {  
  
  uebersicht_text_de <- paste0("<b>",titel_all$Vorlage_d[1],"</b><br>",
                               sum(results$Gebiet_Ausgezaehlt)," von ",nrow(results)," Gemeinden ausgezählt (",
                               round((sum(results$Gebiet_Ausgezaehlt)*100)/nrow(results),1),
                               "%)")
  
  uebersicht_text_fr <- paste0("<b>",titel_all$Vorlage_f[1],"</b><br>",
                               sum(results$Gebiet_Ausgezaehlt)," des ",nrow(results)," communes sont connus (",
                               round((sum(results$Gebiet_Ausgezaehlt)*100)/nrow(results),1),
                               "%)")
  
  uebersicht_text_it <- paste0("<b>",titel_all$Vorlage_i[1],"</b><br>",
                               sum(results$Gebiet_Ausgezaehlt)," dei ",nrow(results)," comuni sono noti (",
                               round((sum(results$Gebiet_Ausgezaehlt)*100)/nrow(results),1),
                               "%)")
  
  if (sum(results$Gebiet_Ausgezaehlt) == nrow(results)) {
    uebersicht_text_de <- paste0("<b>",titel_all$Vorlage_d[1],"</b><br>",
                                 "Es sind alle Gemeinden ausgezählt.")
    
    uebersicht_text_fr <- paste0("<b>",titel_all$Vorlage_f[1],"</b><br>",
                                 "Toutes les communes sont connues.")
    
    uebersicht_text_it <- paste0("<b>",titel_all$Vorlage_i[1],"</b><br>",
                                 "Tutti i comuni sono noti.")
    
    cat(paste0("Resultate von folgender kantonalen Abstimmung aus ",kantone_list$geoLevelname[k]," sind komplett:\n",
                 titel_all$Vorlage_d[1],"\n",
                 titel_all$Vorlage_f[1],"\n",
                 titel_all$Vorlage_i[1],"\n\n"))
    check_counted[i] <- TRUE
  }  
}
  Ja_Anteil <- round(Ja_Stimmen_Kanton,1)
  Nein_Anteil <- round(100-Ja_Stimmen_Kanton,1)
}  

entry_overview <- data.frame(Ja_Anteil,Nein_Anteil,uebersicht_text_de,uebersicht_text_fr,uebersicht_text_it)
colnames(entry_overview) <- c("Ja","Nein","Abstimmung_de","Abstimmung_fr","Abstimmung_it")
data_overview <- rbind(data_overview,entry_overview)
}
data_overview <- data_overview[-1,]
write.csv(data_overview,paste0("Output_Overviews/Uebersicht_dw_",kantone_list$geoLevelname[k],".csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

#Update Datawrapper-Chart
datawrapper_ids <- datawrapper_codes_kantonal %>%
  filter(Typ == "Uebersicht Kanton",
         Vorlage == kantone_list$geoLevelname[k])


for (d in 1:nrow(datawrapper_ids)) {
dw_data_to_chart(data_overview,datawrapper_ids$ID[d])

if (datawrapper_ids$Sprache[d] == "de-DE") {
dw_edit_chart(datawrapper_ids$ID[d],intro=paste0("Letzte Aktualisierung: ",format(Sys.time(),"%H:%M Uhr")))
}
if (datawrapper_ids$Sprache[d] == "fr-CH") {
dw_edit_chart(datawrapper_ids$ID[d],intro=paste0("Dernière mise à jour: ",format(Sys.time(),"%Hh%M")))
}
if (datawrapper_ids$Sprache[d] == "it-CH") {
dw_edit_chart(datawrapper_ids$ID[d],intro=paste0("Ultimo aggiornamento: ",format(Sys.time(),"%H:%M")))
}    
dw_publish_chart(datawrapper_ids$ID[d])
}

if (sum(check_counted) == nrow(vorlagen)) {
cat(paste0("Alle Abstimmungen aus dem Kanton ",kantone_list$geoLevelname[k]," sind ausgezählt!\n\n")) 

completed_cantons <- c(completed_cantons,kantone_list$geoLevelname[k]) 
write_rds(completed_cantons,"completed_cantons.RDS")


#Send Mail
selected_mail <- mail_cantons %>%
  filter(area_ID == kantone_list$geoLevelname[k])

Subject <- paste0("Kanton ",kantone_list$geoLevelname[k],": Kantonale Abstimmungen komplett")
Body <- paste0("Liebes Keystone-SDA-Team,\n\n",
               "Die Ergebnisse der kantonalen Abstimmungen im Kanton ",kantone_list$geoLevelname[k]," sind bekannt. ",
               "Ihr findet die Übersichts-Grafiken unter folgenden Links:\n",
               paste(paste0("https://datawrapper.dwcdn.net/",datawrapper_ids$ID),collapse = "\n"),
               "\n\nBitte falls gewünscht die Übersichtsgrafik sowie die Karten (falls vorhanden) ins Visual hochladen.\n\n",
               "Liebe Grüsse\n\nLENA")
send_notification(Subject,Body,
                  paste0(DEFAULT_MAILS,",",selected_mail$mail_KeySDA[1]))

#Log Kantonale Abstimmungen
cat(paste0("\n\n",Sys.time()," Kantonale Abstimmungen ",kantone_list$geoLevelname[k],"\n"),file="Logfiles/log_file.txt",append = TRUE)
}
}  else {
  cat(paste0("\nKanton ",kantone_list$geoLevelname[k]," bereits komplett\n"))  
}  
}  

