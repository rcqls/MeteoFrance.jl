periodstring(x::UnitRange) = string(x.start) * "-" * string(x.stop)

function urls(db::DataGouvDB, years::AbstractVector{Int}; dep::Vector{String}=String[], base::Vector{String}=String[])
    if !isempty(db.departement)
        if isempty(dep) 
            dep = [db.departement[1]]
        end
    else
        dep = String[]
    end
    if !isempty(db.base)
        if isempty(base)
            base = [db.base[1]]
        end
    else
        base = String[]
    end
    
    if isempty(years)
        return
    end

    period = db.period[map(p -> any(map(y -> y in p, years)), db.period)]
    
    if isempty(period)
        return
    end

    unique!(period)

    np = length(period)
    nd = isempty(dep) ? 1 : length(dep)
    nb = isempty(base) ? 1 : length(base)

    # println((p = period, b=base, d=dep))

    # recycle
    period = repeat(period, nd * nb)
    if !isempty(dep)
        dep =  repeat(dep, inner = nb * np)
    end
    if !isempty(base)
        base = repeat(base, inner = np * nd)
    end
 
    if !isempty(period)
        if db.id in keys(DBS)
            lasttwo = periodstring.(last(db.period, 2))
            period = periodstring.(period)
            period[period .== lasttwo[1]] .= "previous-" * lasttwo[1]
            period[period .== lasttwo[2]] .=  "latest-" * lasttwo[2]
            
        end
    else
        return
    end

    urls = similar(period)
    # println((p = period, b=base, d=dep))
    urls .= db.orig .* db.root .* "_" .* dep .* "_" .* period
    if !isempty(base) 
        urls .*= "_" .* base
    end
    urls .*= "." .* db.extension   
    urls
end