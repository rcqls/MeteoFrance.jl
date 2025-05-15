module MeteoFrance

using Dates, CSV

import Downloads

import DataFrames: DataFrame

export DataFrame

include("db.jl")
include("url.jl")
include("df.jl")

end
