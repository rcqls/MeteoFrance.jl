using MeteoFrance
using Documenter

DocMeta.setdocmeta!(MeteoFrance, :DocTestSetup, :(using MeteoFrance); recursive=true)

makedocs(;
    modules=[MeteoFrance],
    authors="R cqls <rdrouilh@gmail.com>",
    sitename="MeteoFrance.jl",
    format=Documenter.HTML(;
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
