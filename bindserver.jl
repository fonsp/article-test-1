import PlutoBindServer

start_dir = "~"

notebookfiles = let
    jlfiles = vcat(map(walkdir(start_dir)) do (root, dirs, files)
        map(
            filter(files) do file
                occursin(".jl", file)
            end
            ) do file
            joinpath(root, file)
        end
    end...)
    filter(jlfiles) do f
        readline(f) == "### A Pluto.jl notebook ###"
    end
end

PlutoBindServer.run_paths(notebookfiles; port=3456, host="0.0.0.0")