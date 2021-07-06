# R_code_energy.r

############# DAY 2
# https://earthobservatory.nasa.gov/

# Deforestation example
library(raster)
library(RStoolbox)


setwd("~/lab/")
# setwd("/Users/utente/lab") #mac
# setwd("C:/lab/") # windows

defor1 <- brick("defor1_.png")  #defor1 <- brick("defor1_.png")  if errors come out: defor1_.png.jpg

plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")

# Exercise: import the defor2_.jpg image
defor2 <- brick("defor2_.png")  #defor2 <- brick("defor2_.png")  if errors come out: defor2_.png.jpg

plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")

# Exercise: put images one beside the other with par()
par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")


# dvi for the first period
dvi1 <- defor1$defor1_.1 - defor1$defor1_.2

# dev.off()
plot(dvi1)

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme
plot(dvi1, col=cl)

# dvi2 after the cut!
dvi2 <- defor2$defor2_.1 - defor2$defor2_.2
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme
plot(dvi2, col=cl)

# Exercise: put images one beside the other with par()
par(mfrow=c(2,1))
plot(dvi1, col=cl, main="DVI before cut")
plot(dvi2, col=cl, main="DVI after cut")

# difference biomass before cut and after cut
difdvi <- dvi1 -dvi2
# dev.off()
plot(difdvi)

cldif <- colorRampPalette(c('blue','white','red'))(100) 
plot(difdvi, col=cldif, main="amount of energy lost!")

hist(difdvi, col="red")

####### final par!
# defor1
# defor2
# dvi1
# dvi2
# difdvi
# histogram

par(mfrow=c(3,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
plot(dvi1, col=cl, main="biomass before cut")
plot(dvi2, col=cl, main="biomass after cut")
plot(difdvi, col=cldif, main="amount of energy lost!")
hist(difdvi, col="red")



