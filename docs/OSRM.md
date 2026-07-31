# Setting up OSRM routing

The analysis needs a local [OSRM](https://project-osrm.org/) server per metro so it
can compute real road-network distances with no API cost. You have
two options:

- **Option A — Do it yourself**: download OpenStreetMap extracts from Geofabrik and
  process them with Docker.
- **Option B — Use the pre-processed graphs**: download the ready-to-serve OSRM
  files directly (~15 GB) and skip all processing.

Metro → US state extract mapping used throughout:

| Metro        | Geofabrik extract              | Suggested port |
|--------------|--------------------------------|----------------|
| Seattle      | `washington-latest.osm.pbf`    | 5001           |
| Los Angeles  | `california-latest.osm.pbf`    | 5002           |
| Chicago      | `illinois-latest.osm.pbf`      | 5003           |
| Boston       | `massachusetts-latest.osm.pbf` | 5004           |
| Austin       | `texas-latest.osm.pbf`         | 5005           |

---

## Option A — Process it yourself

### 1. Install Docker

[Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/macOS)
or Docker Engine (Linux). On Windows, enable the WSL2 backend.

### 2. Download an extract from Geofabrik

Geofabrik hosts per-region OSM extracts. Downloading every **state** (not the whole US)
keeps RAM manageable. Note: you can use the `Southern California` map for Los Angeles and make sure to rename to `california-latest.osm.pbf`.

```bash
mkdir -p osrm && cd osrm
# Example: Washington (for Seattle)
wget https://download.geofabrik.de/north-america/us/washington-latest.osm.pbf
```

State pages (click the `.osm.pbf` link if you prefer manual download):
https://download.geofabrik.de/north-america/us.html

### 3. Process (once per extract)

Three steps turn a `.osm.pbf` into a servable `.osrm` graph. Use the helper script:

**Linux / macOS:**
```bash
./scripts/process_osrm.sh washington-latest.osm.pbf
```

**Windows PowerShell:**
```powershell
.\scripts\process_osrm.ps1 washington-latest.osm.pbf
```

Or run the three steps manually:
```bash
docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract   -p /opt/car.lua /data/washington-latest.osm.pbf
docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition               /data/washington-latest.osrm
docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-customize               /data/washington-latest.osrm
```

Let each finish before starting the next. `osrm-customize` produces the
`.osrm.datasource_names` file the server needs — if it's missing, that step didn't
complete.

---

## Option B — Use the pre-processed OSRM graphs (~15 GB)

If you'd rather not process anything, download the ready-to-serve `.osrm.*` files
for all five metros:

> **Download link:** https://doi.org/10.4121/8a570c19-9ef1-4769-b511-1a66fa7ac192

Unzip so each metro's `.osrm.*` files sit in your `osrm/` folder, then skip
straight to "Running the servers" below.

---

## Running the servers

One server per metro, each on its own port so the notebook can route all five
without restarts. `--max-table-size 10000` raises the matrix cap; `--algorithm mld`
matches the partition/customize pipeline.

**One at a time (single metro, port 5000):**
```bash
docker run -t -i -p 5000:5000 -v "${PWD}:/data" osrm/osrm-backend \
  osrm-routed --algorithm mld --max-table-size 10000 /data/washington-latest.osrm
```

**All five at once (detached, per-metro ports):**
```bash
./scripts/run_servers.sh        # Linux/macOS
```

**On Windows:**
```PowerShell
docker run -d -p 5001:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/washington-latest.osrm
docker run -d -p 5002:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/california-latest.osrm
docker run -d -p 5003:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/illinois-latest.osrm
docker run -d -p 5004:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/massachusetts-latest.osrm
docker run -d -p 5005:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld --max-table-size 10000 /data/texas-latest.osrm
```

Each server loads its whole graph into RAM, so running all five simultaneously
needs enough memory for the sum. If RAM is tight, run them one at a time and process one metro per pass.

### Verify a server is up
```bash
curl "http://localhost:5001/route/v1/driving/-122.33,47.60;-122.35,47.62?overview=false"
```
A JSON response with `"code":"Ok"` means it's ready.
