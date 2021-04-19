library(devtools)
# remove.packages('MOTRbartTreatEff')
load_all()
document()
check()
build()
install_github("ebprado/MOTR-BART-for-treatment-effects/BARTreatEff")

library(policytree)
n = 10
p = 10
data <- gen_data_mapl(n, p)
data.test <- gen_data_mapl(n, p)

aa = data$X
data$region
