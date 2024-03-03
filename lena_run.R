repeat{
MAIN_PATH <- "C:/Users/simon/OneDrive/LENA_Project/20240303_LENA_Abstimmungen"

#Working Directory definieren
setwd(MAIN_PATH)

###Funktionen laden
source("./Funktionen/functions_readin.R", encoding = "UTF-8")
source("./Funktionen/functions_storyfinder.R", encoding = "UTF-8")
source("./Funktionen/functions_storybuilder.R", encoding = "UTF-8")
source("./Funktionen/functions_output.R", encoding = "UTF-8")
source("./tools/Funktionen/Utils.R", encoding = "UTF-8")

###Config: Bibliotheken laden, Pfade/Links definieren, bereits vorhandene Daten laden
source("CONFIG.R",encoding = "UTF-8")

#Simulate Data (if needed)
simulation <- FALSE
if (simulation == TRUE) {
source("./Simulation/data_simulation.R")  
}  

#Aktualisierungs-Check: Gibt es neue Daten?
timestamp_national <- read.csv("./Timestamp/timestamp_national.txt",header=FALSE)[1,1]
timestamp_kantonal <- read.csv("./Timestamp/timestamp_kantonal.txt",header=FALSE)[1,1]
  
time_check_national <- timestamp_national == json_data$timestamp
time_check_kantonal <- timestamp_kantonal == json_data_kantone$timestamp

#time_check_national <- FALSE
#time_check_kantonal <- FALSE
if ((time_check_national == TRUE) & (time_check_kantonal == TRUE)) {
print("Keine neuen Daten gefunden")  
} else {
print("Neue Daten gefunden")
time_start <- Sys.time()

if (time_check_national == FALSE) {
###Nationale Abstimmungen###
source("nationale_abstimmungen.R", encoding="UTF-8")

#Abstimmung komplett?
mail_sent_report <- read_rds("mail_sent_report.RDS")
if ((mail_sent_report == FALSE) & (sum(json_data[["schweiz"]][["vorlagen"]][["vorlageBeendet"]] == FALSE) == 0) ) {
print("Alle Abstimmungsresultate komplett!")
source("report_election_completed.R", encoding="UTF-8") 
}  
  
}
  
if (time_check_kantonal == FALSE) {  
  
###Kantonale Abstimmungen Uebersicht  
source("kantonale_abstimmungen_uebersicht.R", encoding="UTF-8")

###Kantonale Abstimmungen###
source("kantonale_abstimmungen.R", encoding="UTF-8")

###Kantonale Abstimmungen Sonderfälle###
source("kantonale_abstimmungen_special.R", encoding="UTF-8")

}
  
###Sonderanpassungen###

###Datenfeeds für Kunden###
#source("datenfeeds_kunden.R", encoding="UTF-8")

#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
git2r::cred_token(token)
gitadd()
gitcommit()
gitpush()

if (time_check_national == FALSE) {
#Tabellen aktualisieren
source("votations_mars_2024/top_flop/top_flop_run.R", encoding="UTF-8")

#Make Commit
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
git2r::cred_token(token)
gitadd()
gitcommit()
gitpush()
}

cat("Daten erfolgreich auf Github hochgeladen\n")

#Timestamp speichern
cat(json_data$timestamp, file="./Timestamp/timestamp_national.txt")
cat(json_data_kantone$timestamp, file="./Timestamp/timestamp_kantonal.txt")

#Wie lange hat LENA gebraucht
time_end <- Sys.time()
cat(time_end-time_start)
}

Sys.sleep(10)
}

