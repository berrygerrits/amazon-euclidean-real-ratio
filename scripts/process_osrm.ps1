# Process one OpenStreetMap extract into a servable OSRM (MLD) graph.
# Usage: .\process_osrm.ps1 <extract.osm.pbf>
param([Parameter(Mandatory=$true)][string]$Pbf)

$Base = $Pbf -replace '\.osm\.pbf$',''

Write-Host "==> osrm-extract"
docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/car.lua "/data/$Pbf"

Write-Host "==> osrm-partition"
docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition "/data/$Base.osrm"

Write-Host "==> osrm-customize"
docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-customize "/data/$Base.osrm"

Write-Host "==> done: $Base.osrm is ready to serve"
