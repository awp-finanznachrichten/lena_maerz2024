set.seed(i+100)

#Daten simulieren Gemeinde!!! 
for (a in 1:nrow(results_othervote)) {   #seq(1,nrow(results_othervote),2)

results_othervote$gebietAusgezaehlt[a] = TRUE

results_othervote$jaStimmenAbsolut[a] <- sample(0:10000,1)
results_othervote$neinStimmenAbsolut[a] <- sample(0:10000,1)
results_othervote$gueltigeStimmen[a] <- results_othervote$jaStimmenAbsolut[a] + results_othervote$neinStimmenAbsolut[a]
results_othervote$jaStimmenInProzent[a] <- results_othervote$jaStimmenAbsolut[a]*100/results_othervote$gueltigeStimmen[a]

}
