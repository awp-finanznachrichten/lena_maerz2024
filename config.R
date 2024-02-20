#Bibliotheken laden
library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(ggplot2)
library(stringr)
library(stringi)
library(xml2)
library(rjson)
library(jsonlite)
library(readxl)
library(git2r)
library(DatawRappr)
library(lubridate)
library(httr)
cat("Benoetigte Bibliotheken geladen\n")

#Welche Abstimmung?
abstimmung_date <- "Maerz2024"

res <- GET("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20240303-eidgAbstimmung.json")
json_data <- fromJSON(rawToChar(res$content), flatten = TRUE)

#download.file("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20240303-eidgAbstimmung.json,
#              destfile = "Data/sd-t-17-02-20240303-eidgAbstimmung.json",
#              method = "curl")
#json_data <- fromJSON("Data/sd-t-17-02-20240303-eidgAbstimmung.json, flatten = TRUE)

res <- GET("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20240303-kantAbstimmung.json")
json_data_kantone <- fromJSON(rawToChar(res$content), flatten = TRUE)
View(json_data_kantone)
#download.file("https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20240303-kantAbstimmung.json",
#              destfile = "Data/sd-t-17-02-20240303-kantAbstimmung.json"",
#              method = "curl")
#json_data_kantone <- fromJSON("Data/sd-t-17-02-20240303-kantAbstimmung.json", flatten = TRUE)

cat("Aktuelle Abstimmungsdaten geladen\n")

excel_sheets <- excel_sheets(paste0("Data/Textbausteine_LENA_",abstimmung_date,".xlsx"))
#Kurznamen Vorlagen (Verwendet im File mit den Textbausteinen)
vorlagen_short <- excel_sheets[2:3]
vorlagen_short
###Kurznamen und Nummern kantonale Vorlagen
kantonal_short <- excel_sheets[c(4:9,11:12,15:16)]

#Nummer in JSON 
kantonal_number <- c(2,6,9,9,9,9,3,8,1,1) 

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswaehlen
kantonal_add <- c(1,1,2,3,4,5,1,2,6,5)

###Kurznamen und Nummern kantonale Vorlagen Spezialfaelle
kantonal_short_special <- excel_sheets[c(10,13,14)]

#Nummer in JSON 
kantonal_number_special <- c(9,8,1) 

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswaehlen
kantonal_add_special <- c(6,1,1)

#Spezialfälle
other_check <- FALSE

#Kantonale Vorlagen Titel
Vorlagen_Titel <- as.data.frame(read_excel(paste0("Data/Textbausteine_LENA_",abstimmung_date,".xlsx"), 
                                          sheet = "Vorlagen_Uebersicht"))

###Anzahl, Name und Nummer der Vorlagen von JSON einlesen

##Deutsch
vorlagen <- get_vorlagen(json_data,"de")
vorlagen$text[1] <- Vorlagen_Titel$Vorlage_d[1]
vorlagen$text[2] <- Vorlagen_Titel$Vorlage_d[2]

#Französisch
vorlagen_fr <- get_vorlagen(json_data,"fr")
vorlagen_fr$text[1] <- Vorlagen_Titel$Vorlage_f[1]
vorlagen_fr$text[2] <- Vorlagen_Titel$Vorlage_f[2]

#Italienisch
vorlagen_it <- get_vorlagen(json_data,"it")
vorlagen_it$text[1] <- Vorlagen_Titel$Vorlage_i[1]
vorlagen_it$text[2] <- Vorlagen_Titel$Vorlage_i[2]

###Vorhandene Daten laden
#daten_co2_bfs <- read_excel("Data/daten_co2_bfs.xlsx",skip=5)
#daten_covid1_bfs <- read_excel("Data/daten_covid1_bfs.xlsx",skip=5)
#daten_covid2_bfs <- read_excel("Data/daten_covid2_bfs.xlsx",skip=5)

cat("Daten zu historischen Abstimmungen geladen\n")

#Metadaten Gemeinden und Kantone
meta_gmd_kt <- read_csv("Data/MASTERFILE_GDE.csv")
cantons_overview <- readRDS("./Data/cantons_overview.RDS")

cat("Metadaten zu Gemeinden und Kantonen geladen\n")

#Datawrapper-Codes
datawrapper_codes <- as.data.frame(read_excel("Data/metadaten_grafiken_eidgenössische_Abstimmungen.xlsx"))
datawrapper_codes_kantonal <- as.data.frame(read_excel("Data/metadaten_grafiken_kantonale_Abstimmungen.xlsx"))
datawrapper_codes_kantonal <- datawrapper_codes_kantonal[,c(1:5)]

datawrapper_auth(Sys.getenv("DW_KEY"), overwrite = TRUE)

gitcommit <- function(msg = "commit from Rstudio", dir = getwd()){
  cmd = sprintf("git commit -m\"%s\"",msg)
  system(cmd)
}

gitstatus <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git status"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitadd <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git add --all"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitpush <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git push"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}


