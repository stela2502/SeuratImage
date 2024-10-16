#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <path> <version> <name>"
    exit 1
fi

# Variables from arguments
PATH_ARG=$1
VERSION=$2
IMAGE_NAME=$3

# Define the output module file path
MODULE_FILE="modules/${IMAGE_NAME}/${VERSION}.lua"

# Ensure the directory exists
mkdir -p "$(dirname "$MODULE_FILE")"

# Create the module file
cat <<EOF 
help([[This module is an example Singularity Image prowiding  
       a 'naked' Python Jupyter Lab interface to both Python and R ]])

local version = "$VERSION"
local base = pathJoin("$PATH_ARG")

-- Define possible mount points
local mounts = {
    "/local",
    "/projects",
    "/scale",
    "/sw"
}

-- Prepare the bind paths environment variable
local bind_paths = ""

-- Function to check if a path exists
local function path_exists(path)
    local attr = lfs.attributes(path)
    return (attr and attr.mode == "directory")
end

-- Check each mount point and only add existing ones
for _, path in ipairs(mounts) do
    if path_exists(path) then
        if bind_paths == "" then
            bind_paths = path  -- First valid path
        else
            bind_paths = bind_paths .. "," .. path  -- Append valid path
        end
    end
end

-- If any valid bind paths exist, set the environment variable for Apptainer
if bind_paths ~= "" then
    bind_paths = "-B "..bind_paths
end

-- this happens at load
run_this="jupyter lab --ip=0.0.0.0 --no-browser --allow-root"
execute{cmd="singularity exec "..bind_paths.." ".. base.. "/${IMAGE_NAME}_v".. version ..".sif "..run_this ,modeA={"load"}}

-- this happens at unload
-- could also do "conda deactivate; " but that should be part of independent VE module

-- execute{cmd="exit",modeA={"load"}}

whatis("Name         : ${IMAGE_NAME} singularity image")
whatis("Version      : ${IMAGE_NAME} $VERSION")
whatis("Category     : Image")
whatis("Description  : Singularity image providing Python and R and a jupyter lab as default entry point ")
whatis("Installed on : $(date +'%d/%m/%Y') ")
whatis("Modified on  : --- ")
whatis("Installed by : \`whomai\`")

family("images")

-- Change Module Path
--local mroot = os.getenv("MODULEPATH_ROOT")
--local mdir = pathJoin(mroot,"Compiler/anaconda",version)
--prepend_path("MODULEPATH",mdir)
--
EOF


