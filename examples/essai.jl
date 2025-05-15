using MeteoFrance

db = MeteoFrance.DBS[:BASEHOR]
db.period

# keys(MeteoFrance.DBS)
# year = [1853,2001,1995]
# map(p -> any(map(y -> y in p, year)), db.period)
# period = db.period[map(p -> any(map(y -> y in p, year)), db.period)]

# lasttwo = MeteoFrance.periodstring.(last(db.period, 2))
# period = MeteoFrance.periodstring.(period)
# period[period .== lasttwo[1]] .= "previous-" * lasttwo[1]
# period[period .== lasttwo[2]] .=  "latest-" * lasttwo[2]
# period
db.base
db.departement

u = MeteoFrance.urls(db,[1990,2001])

CSV.read(Downloads.download(u[1],DataFrame))


DataFrame[db,[1990,2001]]