#lecture 2 on ecological variables

install.packages("sp")
library(sp)
data(meuse)
pairs(meuse)
pairs(meuse[,3:6])  #start show only column 3 to 6 of a data set

pairs(~ cadmium + copper + lead + zinc, data=meuse)

