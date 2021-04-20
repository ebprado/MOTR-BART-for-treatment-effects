library(devtools)
remove.packages('MOTRbartTreatEff')
load_all()
document()
check()
build()
install_github("ebprado/MOTR-BART-for-treatment-effects/BARTreatEff")

library(BARTreatEff)
library(policytree)
n = 500
p = 10
data <- gen_data_mapl(n, p)
x = as.data.frame(data$X)
y = data$Y

motr_bart_fit = BARTreatEff::motr_bart(x, x_binary = c('V1', 'V2', 'V4'), y = y, var_linear_pred = 'binary treatments')
