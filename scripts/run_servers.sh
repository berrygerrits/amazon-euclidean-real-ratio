#!/usr/bin/env bash
# Launch one detached OSRM server per metro, each on its own port.
# Run from the folder containing the processed .osrm files.
set -euo pipefail

declare -A GRAPHS=(
  [5001]="washington-latest.osrm"     # Seattle
  [5002]="california-latest.osrm"      # Los Angeles
  [5003]="illinois-latest.osrm"        # Chicago
  [5004]="massachusetts-latest.osrm"   # Boston
  [5005]="texas-latest.osrm"           # Austin
)

for PORT in "${!GRAPHS[@]}"; do
  GRAPH="${GRAPHS[$PORT]}"
  if [ ! -f "$GRAPH" ]; then
    echo "SKIP port $PORT: $GRAPH not found"; continue
  fi
  echo "Starting $GRAPH on port $PORT"
  docker run -d -p "${PORT}:5000" -v "${PWD}:/data" osrm/osrm-backend \
    osrm-routed --algorithm mld --max-table-size 10000 "/data/${GRAPH}"
done

echo "Running containers:"
docker ps --format 'table {{.Ports}}\t{{.Command}}'

# --- Windows PowerShell equivalent (run each line yourself) ---
# docker run -d -p 5001:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/washington-latest.osrm
# docker run -d -p 5002:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/california-latest.osrm
# docker run -d -p 5003:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/illinois-latest.osrm
# docker run -d -p 5004:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/massachusetts-latest.osrm
# docker run -d -p 5005:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/texas-latest.osrm
