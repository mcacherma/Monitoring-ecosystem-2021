#R spatial

#install sp, meuse, head meuse, data meuse

coordinates(meuse) = ~x+y
spplot(meuse, "zinc")
spplot(meuse, c("zinc","copper"))

bubble(meuse,"zinc")
