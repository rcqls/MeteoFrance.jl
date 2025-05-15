function Base.getindex(::Type{DataFrame}, db::DataGouvDB, years::AbstractVector{Int}; kwargs...)
    dfs = Dict{String,DataFrame}() 
    for url = urls(db, years; kwargs...)
        dfs[url] = CSV.read(Downloads.download(url),DataFrame)
    end
    dfs
end