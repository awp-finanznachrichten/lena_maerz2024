#repeat{

#Working Directory definieren
setwd("C:/Users/sw/OneDrive/LENA_Project/20240303_LENA_Abstimmungen")

###Funktionen laden
source("./Funktionen/functions_readin.R", encoding = "UTF-8")
source("./Funktionen/functions_storyfinder.R", encoding = "UTF-8")
source("./Funktionen/functions_storybuilder.R", encoding = "UTF-8")
source("./Funktionen/functions_output.R", encoding = "UTF-8")
source("./tools/Funktionen/Utils.R", encoding = "UTF-8")

###Config: Bibliotheken laden, Pfade/Links definieren, bereits vorhandene Daten laden
source("CONFIG.R",encoding = "UTF-8")

#Simulate Data (if needed)
simulation <- TRUE
if (simulation == TRUE) {
source("./Simulation/data_simulation.R")  
}  

#Aktualisierungs-Check: Gibt es neue Daten?
timestamp_national <- read.csv("./Timestamp/timestamp_national.txt",header=FALSE)[1,1]
timestamp_kantonal <- read.csv("./Timestamp/timestamp_kantonal.txt",header=FALSE)[1,1]
  
time_check_national <- timestamp_national == json_data$timestamp
time_check_kantonal <- timestamp_kantonal == json_data_kantone$timestamp

time_check_national <- FALSE
time_check_kantonal <- FALSE
if ((time_check_national == TRUE) & (time_check_kantonal == TRUE)) {
print("Keine neuen Daten gefunden")  
} else {
print("Neue Daten gefunden")
time_start <- Sys.time()

if (time_check_national == FALSE) {
###Nationale Abstimmungen###
source("nationale_abstimmungen.R", encoding="UTF-8")
}
  
if (time_check_kantonal == FALSE) {  
###Kantonale Abstimmungen###
source("kantonale_abstimmungen.R", encoding="UTF-8")

###Kantonale Abstimmungen Uebersicht  
source("kantonale_abstimmungen_uebersicht.R", encoding="UTF-8")

###Kantonale Abstimmungen Sonderfälle###
source("kantonale_abstimmungen_special.R", encoding="UTF-8")

}
  
###Sonderanpassungen###

###Datenfeeds für Kunden###
#source("datenfeeds_kunden.R", encoding="UTF-8")

#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
token <- read.csv("C:/Users/sw/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
git2r::cred_token(token)
gitadd()
gitcommit()
gitpush()

if (time_check_national == FALSE) {
#Tabellen aktualisieren
#source("./top_flop/top_flop_chartbuilder_de-2144680.R", encoding = "UTF-8")
#source("./top_flop/top_flop_chartbuilder_fr-2144681.R", encoding = "UTF-8")
#source("./top_flop/top_flop_chartbuilder_it-2144682.R", encoding = "UTF-8")

#Make Commit
token <- read.csv("C:/Users/sw/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
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

#Sys.sleep(60)
#}

