@kwdef struct DataGouvDB
    id::Symbol
    name::String
    man::String
    orig::String
    root::String
    departement::Vector{String} = []
    period::Vector{AbstractRange{Int}} = []
    base::Vector{String} = []
    extension::String = "csv.gz"
    descriptif::String = "descriptif_champs.csv"
    copyright::String = "MeteoFrance"
end

function show(io::IO, db::DataGouvDB) 
    print(io, "A database from data.gouv.fr named ", db.name, " described at ", db.man)
    if !isnothing(db.copyright)
        print(io, " provided by ", db.copyright)
    end
    println(io)
end

const infos = Dict(
    #France mainland
    :dep => lpad.(1:95, 2, "0"),
    :domtom => string.([971:975; 984:988]),
    #:year1800 => UnitRange.(1850:10:1890,1859:10:1899) #not yet available
    :year1800 => [1850:1859, 1890:1899],
    :year1900 => UnitRange.(1900:10:1990,1909:10:1999),
    :year2000 => [2000:2009, 2010:2019],
#   #compute year, day, month as computed on https://meteo.data.gouv.fr/datasets/
    :currentyear => year(Dates.now()),
    :currentmonth => month(Dates.now()),
    :currentday => day(Dates.now()),
#   lastmth_chr <- ifelse(nchar(as.character(currentmonth-1)) == 1, paste0("0", currentmonth-1), currentmonth-1)
#   currentmonth_chr <- ifelse(nchar(as.character(currentmonth)) == 1, paste0("0", currentmonth), currentmonth)
#   lastday_chr <- ifelse(nchar(as.character(currentday-1)) == 1, paste0("0", currentday-1), currentday-1)
    :currentdecade => [2020:year(Dates.now())-2],
#   currentdecademonth <- paste0("2020-", currentyear, lastmth_chr)
#   currentmonth <- paste0(currentyear, lastmth_chr, "01-", currentyear, currentmonth_chr, lastday_chr)
    :lasttwoyears => [year(Dates.now()) .+ (-1:0)],
    :y1950_yearminus2 => [1950:year(Dates.now())-2]
)

const DBS = Dict(
    :BASEMIN => DataGouvDB( #data minutely
        id = :BASEMIN,
        name = "Données climatologiques de base - 6 minutes",
        man = "https://meteo.data.gouv.fr/datasets/6569ad61106d1679c93cdf77",
        orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/MIN/",
        root = "MN",
        departement = [infos[:dep]; infos[:domtom]],
        period = [infos[:year2000]; infos[:currentdecade]; infos[:lasttwoyears]]
    ),
    :BASEHOR => DataGouvDB( #data hourly
        id = :BASEHOR,
        name = "Données climatologiques de base - horaires",
        man = "https://meteo.data.gouv.fr/datasets/6569b4473bedf2e7abad3b72",
        orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/HOR/",
        root = "H",
        departement = [infos[:dep]; infos[:domtom]],
        period = [infos[:year1800]; infos[:year1900]; infos[:year2000]; infos[:currentdecade]; infos[:lasttwoyears]]
    ) #,
    # :BASEQUOT => DataGouvDB(#data daily
    #     id = :BASEQUOT,
    #     name = "Données climatologiques de base - quotidiennes",
    #     man = "https://meteo.data.gouv.fr/datasets/6569b51ae64326786e4e8e1a",
    #     orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/QUOT/",
    #     root = "Q",
    #     departement = [infos[:dep]; infos[:domtom]],
    #     period = [y1950_yearminus2, lasttwoyears],
    #     base = ["RR-T-Vent", "autres-parametres"] 
    # ),
    # :BASEDECAD => DataGouvDB( #data by decade
    #     id= :BASEDECAD,
    #     name = "Données climatologiques de base - décadaires",
    #     man = "https://meteo.data.gouv.fr/datasets/6569b4a48a4161faec6b2779",
    #     orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/DECAD/",
    #     root = "DECADQ",
    #     departement = [infos[:dep]; infos[:domtom]],
    #     period = [y1950_yearminus2, lasttwoyears]
    # ),
    # :BASEDECADAGRO => DataGouvDB( #data by decade for agriculture
    #     id = :BASEDECADAGRO,
    #     name = "Données climatologiques de base - décadaires agricoles",
    #     man = "https://meteo.data.gouv.fr/datasets/6569af36ba0c3d2f9d4bf98c",
    #     orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/DECADAGRO/",
    #     root = "DECADAGRO",
    #     departement = [infos[:dep]; infos[:domtom]],
    #     period = [y1950_yearminus2, lasttwoyears]
    # ),
    # :BASEMENS => DataGouvDB( #data monthly
    #     id = :BASEMENS,
    #     name = "Données climatologiques de base - mensuelles",
    #     man = "https://meteo.data.gouv.fr/datasets/6569b3d7d193b4daf2b43edc",
    #     orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/MENS/",
    #     root = "MENSQ",
    #     departement = [infos[:dep]; infos[:domtom]],
    #     period = [y1950_yearminus2, lasttwoyears]
    # ),
    # :SIMUL => DataGouvDB(#data monthly
    #     id = :SIMUL,
    #     name = "Données changement climatique - SIM quotidienne",
    #     man = "https://meteo.data.gouv.fr/datasets/6569b27598256cc583c917a7",
    #     orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/REF_CC/SIM/",
    #     root = "QUOT_SIM2",
    #     period = ["1958-1959", yearlist1900[7:10], yearlist2000, currentdecademonth, currentmonth]
    # )
 
)

#   yearlist1800 <- paste0("18", 5:9, "0-18", 5:9, "9") #not yet available
#   yearlist1800 <- c("1850-1859", "1890-1899")
#   yearlist1900 <- paste0("19", 0:9, "0-19", 0:9, "9")
#   yearlist2000 <- paste0("20", 0:1, "0-20", 0:1, "9")
#   #compute year, day, month as computed on https://meteo.data.gouv.fr/datasets/
#   currentyear <- as.numeric(format(Sys.Date(), "%Y"))
#   currentmonth <- as.numeric(format(Sys.Date(), "%m"))
#   currentday <- as.numeric(format(Sys.Date(), "%d"))
#   lastmth_chr <- ifelse(nchar(as.character(currentmonth-1)) == 1, paste0("0", currentmonth-1), currentmonth-1)
#   currentmonth_chr <- ifelse(nchar(as.character(currentmonth)) == 1, paste0("0", currentmonth), currentmonth)
#   lastday_chr <- ifelse(nchar(as.character(currentday-1)) == 1, paste0("0", currentday-1), currentday-1)
  
#   currentdecade <- paste0("2020-", currentyear-2)
#   currentdecademonth <- paste0("2020-", currentyear, lastmth_chr)
#   currentmonth <- paste0(currentyear, lastmth_chr, "01-", currentyear, currentmonth_chr, lastday_chr)
#   lasttwoyears <- paste0(currentyear-1, "-", currentyear)
#   y1950_yearminus2 <- paste0("1950-", currentyear-2)
  
#   #data minutely
#   MFBASEMIN <- dbdatagouv(name = "Donn\u00E9es climatologiques de base - 6 minutes",
#                           man = "https://meteo.data.gouv.fr/datasets/6569ad61106d1679c93cdf77",
#                           orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/MIN/",
#                           root = "MN",
#                           departement = c(deplist1, deplist2),
#                           period = c(yearlist2000, currentdecade, lasttwoyears),
#                           base = NULL,
#                           extension = "csv.gz",
#                           cph = "MeteoFrance",
#                           "descriptif_champs.csv")
  
#   #data hourly
#   MFBASEHOR <- dbdatagouv(name = "Donn\u00E9es climatologiques de base - horaires",
#                           man = "https://meteo.data.gouv.fr/datasets/6569b4473bedf2e7abad3b72",
#                           orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/HOR/",
#                           root = "H",
#                           departement = c(deplist1, deplist2),
#                           period = c(yearlist1800, yearlist1900, yearlist2000, currentdecade, lasttwoyears),
#                           base = NULL,
#                           extension = "csv.gz",
#                           cph = "MeteoFrance",
#                           "descriptif_champs.csv")
  
#   #data daily
#   MFBASEQUOT <- dbdatagouv(name = "Donn\u00E9es climatologiques de base - quotidiennes",
#                            man = "https://meteo.data.gouv.fr/datasets/6569b51ae64326786e4e8e1a",
#                            orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/QUOT/",
#                            root = "Q",
#                            departement = c(deplist1, deplist2),
#                            period = c(y1950_yearminus2, lasttwoyears),
#                            base = c("RR-T-Vent", "autres-parametres"),
#                            extension = "csv.gz",
#                            cph = "MeteoFrance",
#                            "descriptif_champs.csv")
#   #data by decade
#   MFBASEDECAD <- dbdatagouv(name = "Donn\u00E9es climatologiques de base - d\u00E9cadaires",
#                             man = "https://meteo.data.gouv.fr/datasets/6569b4a48a4161faec6b2779",
#                             orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/DECAD/",
#                             root = "DECADQ",
#                             departement = c(deplist1, deplist2),
#                             period = c(y1950_yearminus2, lasttwoyears),
#                             base = NULL,
#                             extension = "csv.gz",
#                             cph = "MeteoFrance",
#                             "descriptif_champs.csv")
  
#   #data by decade for agriculture
#   MFBASEDECADAGRO <- dbdatagouv(name = "Donn\u00E9es climatologiques de base - d\u00E9cadaires agricoles",
#                                 man = "https://meteo.data.gouv.fr/datasets/6569af36ba0c3d2f9d4bf98c",
#                                 orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/DECADAGRO/",
#                                 root = "DECADAGRO",
#                                 departement = c(deplist1, deplist2),
#                                 period = c(y1950_yearminus2, lasttwoyears),
#                                 base = NULL,
#                                 extension = "csv.gz",
#                                 cph = "MeteoFrance",
#                                 "descriptif_champs.csv")
  
#   #data monthly
#   MFBASEMENS <- dbdatagouv(name = "Donn\u00E9es climatologiques de base - mensuelles",
#                            man = "https://meteo.data.gouv.fr/datasets/6569b3d7d193b4daf2b43edc",
#                            orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/MENS/",
#                            root = "MENSQ",
#                            departement = c(deplist1, deplist2),
#                            period = c(y1950_yearminus2, lasttwoyears),
#                            base = NULL,
#                            extension = "csv.gz",
#                            cph = "MeteoFrance",
#                            "descriptif_champs.csv")
  
#   #data monthly
#   MFSIMUL <- dbdatagouv(name = "Donn\u00E9es changement climatique - SIM quotidienne",
#                         man = "https://meteo.data.gouv.fr/datasets/6569b27598256cc583c917a7",
#                         orig = "https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/REF_CC/SIM/",
#                         root = "QUOT_SIM2",
#                         departement = NULL,
#                         period = c("1958-1959", yearlist1900[7:10], yearlist2000, currentdecademonth, currentmonth),
#                         base = NULL,
#                         extension = "csv.gz",
#                         cph = "MeteoFrance",
#                         "descriptif_champs.csv")
  
#   list("BASEMIN"=MFBASEMIN, "BASEHOR"=MFBASEHOR, "BASEQUOT"=MFBASEQUOT, "BASEDECAD"=MFBASEDECAD, 
#        "BASEDECADAGRO"=MFBASEDECADAGRO, "BASEMENS"=MFBASEMENS, "QUOTSIM"=MFSIMUL)
# }