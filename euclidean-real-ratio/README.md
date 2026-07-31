# The Ratio Between Real and Euclidean Distance

Computing the ratio of real (road-network) distance to Euclidean distance for
**actually driven** last-mile delivery tours, using the Amazon Last Mile Routing
Research Challenge dataset routed over OpenStreetMap.

The headline output is a single number: the stop-weighted mean detour factor
across all routes in all five metropolitan areas.

## What this repo does

For every historical Amazon delivery route, it computes two distances along the
driver's actual visit sequence:

- **Euclidean length** — sum of straight-line (haversine) distances between
  consecutive stops.
- **Real length** — the same path routed over the real road network via a local
  [OSRM](https://project-osrm.org/) server (no per-request API cost).

The **detour factor** is their ratio. The notebook aggregates these into a single
stop-weighted mean over all routes.

Two tour definitions are supported:
- **A** — closed tour: depot → all stops → depot.
- **B** — open path across delivery stops only: first → last.

## Quick start

1. **Get the data** — [`docs/DATA.md`](docs/DATA.md): download the ALMRRC dataset.
2. **Set up routing** — [`docs/OSRM.md`](docs/OSRM.md): either
   - download OpenStreetMap extracts from Geofabrik and process them with Docker, or
   - download the ~15 GB pre-processed OSRM graphs directly (link in that doc).
3. **Run the notebook** — [`notebooks/compute_detour.ipynb`](notebooks/compute_detour.ipynb):
   plug in your data loader, run all cells, read the single number at the bottom.

## Requirements

- Python 3.9+ with `numpy`, `pandas`, `requests`, `jupyter` (see `requirements.txt`)
- Docker Desktop (only if you process OSM extracts yourself)
- ~15–30 GB free disk depending on how many metros you route

## Repository layout

```
.
├── README.md
├── requirements.txt
├── docs/
│   ├── DATA.md          # how to get the Amazon dataset
│   └── OSRM.md          # Geofabrik + Docker, or the pre-processed download
├── scripts/
│   ├── process_osrm.sh        # one-shot OSM extract -> OSRM graph (Linux/macOS)
│   ├── process_osrm.ps1       # same, for Windows PowerShell
│   └── run_servers.sh         # launch one OSRM server per metro
└── notebooks/
    └── compute_detour.ipynb   # main analysis -> single weighted-mean number
```

## Citation

Dataset: Merchán, D., Arora, J., Pachon, J., Konduri, K., Winkenbach, M., Parks,
S., Noszek, J. (2022). 2021 Amazon Last Mile Routing Research Challenge: Data Set.
*Transportation Science* 58(1):8–11. https://doi.org/10.1287/trsc.2022.1173

## License

Code released under the MIT License. The Amazon dataset is governed separately by
its own CC BY-NC 4.0 license — see `docs/DATA.md`.
