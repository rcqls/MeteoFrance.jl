import Base: getindex

function getindex(::Type{DataFrame}, db::DataGouvDB, years::AbstractVector{Int}; kwargs...)
    dfs = Dict{String,DataFrame}() 
    for url = urls(db, years; kwargs...)
        dfs[url] = CSV.read(Downloads.download(url),DataFrame)
    end
    dfs
end


# Careful: years is a Tuple so [years...] is a Vector{Int} (collect(years) would do the same)
getindex(::Type{DataFrame}, db::DataGouvDB, years...; kwargs...) = getindex(DataFrame, db , [years...]; kwargs...)
    
    