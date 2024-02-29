library(readxl)

(cor(age_korrelation$`Anteil ü65-Jährige`,age_korrelation$`Ja-Anteil 13. AHV-Rente`))^2

cor.test(age_korrelation$`Anteil ü65-Jährige`,age_korrelation$`Ja-Anteil 13. AHV-Rente`,paired = TRUE)
plot(age_korrelation$`Anteil ü65-Jährige`,age_korrelation$`Ja-Anteil 13. AHV-Rente`)
