# comprob easy share

library(foreign)
easyshare <- read.dta("../an_longitudinal/data/easySHARE_rel1-0-0_stata/easySHARE_rel1-0-0.dta")

easyshare$id_across_wave <- paste(easyshare$mergeid, easyshare$wave,sep="_")

save(easyshare, file="tempData/easyshare.RData")