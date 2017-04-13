library(RSAGA)
library(raster)
library(rgdal)
library(ggplot2)
library(RColorBrewer)

#note that you want the cell resolution of your dem to be symmetrical res.x = res.y
dem <- raster("dem.tif")

myenv <- rsaga.env(modules  = "/usr/local/lib/saga")

writeRaster(dem, filename="elev.sgrd", format="SAGA", overwrite=TRUE, prj = T)

rsaga.wetness.index(in.dem = "elev.sgrd",
                    out.wetness.index = "twi.sgrd",
                    env = myenv)

twi <- raster(readGDAL("twi.sdat"))

crs(twi) <- crs(dem)

twi.df <- data.frame(rasterToPoints(twi))

twi.gg <- ggplot(data = twi.df, aes(x=x, y=y, fill=band1))+
  geom_raster()+
  scale_fill_gradientn(colors = brewer.pal(9, "Blues"), name = "TWI") +
  xlab("")+
  ylab("") +
  theme_bw()

png("twi.png",
    width = 4,
    height = 3,
    units = "in",
    res = 600)
twi.gg
dev.off()


