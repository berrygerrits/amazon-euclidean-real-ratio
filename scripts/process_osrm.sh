#!/usr/bin/env bash
# Process one OpenStreetMap extract into a servable OSRM (MLD) graph.
# Usage: ./process_osrm.sh <extract.osm.pbf>
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <extract.osm.pbf>"; exit 1
fi

PBF="$1"
BASE="${PBF%.osm.pbf}"

echo "==> osrm-extract"
docker run -t -v "${PWD}:/data" osrm/osrm-backend \
  osrm-extract -p /opt/car.lua "/data/${PBF}"

echo "==> osrm-partition"
docker run -t -v "${PWD}:/data" osrm/osrm-backend \
  osrm-partition "/data/${BASE}.osrm"

echo "==> osrm-customize"
docker run -t -v "${PWD}:/data" osrm/osrm-backend \
  osrm-customize "/data/${BASE}.osrm"

echo "==> done: ${BASE}.osrm is ready to serve"
