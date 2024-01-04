source("./top_flop/helpers-2144679.R")

#UPDATE data top_flop_it
ocde_top_it <- top_flop(ocde,"top","it")
climat_top_it <- top_flop(climat,"top","it")
covid_top_it <- top_flop(covid,"top","it")

ocde_flop_it <- top_flop(ocde,"flop","it")
climat_flop_it <- top_flop(climat,"flop","it")
covid_flop_it <- top_flop(covid,"flop","it")


#OCDE TOP
chart_metadata <- dw_retrieve_chart_metadata("Rm3OV")
intro_text_it <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "qnl4B"

dw_data_to_chart(ocde_top_it,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_it,
              title = "Comuni che hanno accolto nella maniera più netta l'imposizione delle grandi imprese secondo gli standard dell'OCSE",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/OECD_Mindeststeuer_all_data.csv")

dw_publish_chart(chart_ID)

#OCDE FLOP
chart_ID <- "F3tYl"

dw_data_to_chart(ocde_flop_it,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_it,
              title = "Comuni che si sono maggiormente opposti all'imposizione delle imprese secondo gli standard dell'OCSE",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/OECD_Mindeststeuer_all_data.csv")

dw_publish_chart(chart_ID)

#Climat
#TOP 
chart_metadata <- dw_retrieve_chart_metadata("C7ve3")
intro_text_it <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "AufUa"

dw_data_to_chart(climat_top_it,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_it,
              title = "Comuni maggiormente favorevoli alla legge sul clima",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Klima_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#FLOP
chart_ID <- "9z3OU"

dw_data_to_chart(climat_flop_it,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_it,
              title = "Comuni maggiormente contrari alla legge sul clima",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Klima_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#COVID
#TOP
chart_metadata <- dw_retrieve_chart_metadata("v1sVB")
intro_text_it <- gsub("[.].*","",chart_metadata$content$metadata$describe$intro)

chart_ID <- "73mFO"

dw_data_to_chart(covid_top_it,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_it,
              title = "Comjni maggiormente favorevoli alla legge Covid",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Covid_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)

#FLOP
chart_ID <- "4bUgk"

dw_data_to_chart(covid_flop_it,chart_ID)

dw_edit_chart(chart_ID,
              intro = intro_text_it,
              title = "Comuni maggiormente contrari alla legge Covid",
              source_name = "OFS",
              source_url = "https://raw.githubusercontent.com/awp-finanznachrichten/lena_juni2023/main/Output/Covid_Gesetz_all_data.csv")

dw_publish_chart(chart_ID)
