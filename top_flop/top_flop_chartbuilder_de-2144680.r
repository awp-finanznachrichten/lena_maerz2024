source("./top_flop/helpers-2144679.R")


#Update data top_flop_de

ocde_top_de <- top_flop(ocde,"top","de")
climat_top_de <- top_flop(climat,"top","de")
covid_top_de <- top_flop(covid,"top","de")

ocde_flop_de <- top_flop(ocde,"flop","de")
climat_flop_de <- top_flop(climat,"flop","de")
covid_flop_de <- top_flop(covid,"flop","de")


#OCDE
chart_metadata <- dw_retrieve_chart_metadata("GwAFG")
intro_text_de <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "q9he8"
dw_data_to_chart(ocde_top_de,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_de,
              title = "Die Gemeinden, welche die OECD-Steuer am deutlichsten angenommen haben",
              source_name = "BFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/OECD_Mindeststeuer_all_data.csv")

dw_publish_chart(chart_ID)

#OCDE FLOP
chart_ID <- "XZIZU"

dw_data_to_chart(ocde_flop_de,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_de,
              title = "Die Gemeinden, welche die OECD-Steuer am deutlichesten abgelehnt haben",
              source_name = "BFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/OECD_Mindeststeuer_all_data.csv")

dw_publish_chart(chart_ID)


#Climat
#TOP 
chart_metadata <- dw_retrieve_chart_metadata("X2GZ2")
intro_text_de <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "LVmpe"

dw_data_to_chart(climat_top_de,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_de,
              title = "Die Gemeinden mit der grössten Zustimmung zum CO2-Gesetz",
              source_name = "BFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Klima_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#FLOP
chart_ID <- "lp54i"

dw_data_to_chart(climat_flop_de,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_de,
              title = "Die Gemeinden mit der grössten Ablehnung des CO2-Gesetzes",
              source_name = "BFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Klima_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#COVID
#TOP
chart_metadata <- dw_retrieve_chart_metadata("x27Qd")
intro_text_de <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "hpQ8R"

dw_data_to_chart(covid_top_de,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_de,
              title = "Die Gemeinden mit der grössten Zustimmung zum Covid-Gesetz",
              source_name = "BFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Covid_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#FLOP
chart_ID <- "n6lho"
dw_data_to_chart(covid_flop_de,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_de,
              title = "Die Gemeinden mit der grössten Ablehnung des Covid-Gesetzes",
              source_name = "BFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Covid_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)
