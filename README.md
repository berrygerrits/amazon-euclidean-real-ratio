# The Ratio Between Real and Euclidean Distance

Computing the ratio of real (road-network) distance to Euclidean distance for
actually driven last-mile delivery tours, using the Amazon Last Mile Routing
Research Challenge dataset routed over OpenStreetMap.

## What this repo does

For every historical Amazon delivery route, it computes two distances along the
driver's actual visit sequence:

- **Euclidean length** — sum of straight-line (haversine) distances between
  consecutive stops.
- **Real length** — the same path routed over the real road network via a local
  [OSRM](https://project-osrm.org/) server (no per-request API cost).

We are interested in the ratio between the real length and the Euclidean length. We call this ratio the **Golden Ratio**.¹

> ¹ As a friendly nod to **Bruce L. Golden** (University of Maryland), a vehicle routing guru.

The distance is measured along the full route the driver actually drove:
depot → all stops → depot.

[`notebooks/compute_ratio.ipynb`](notebooks/compute_ratio.ipynb) shows that the mean Golden Ratio is ≈ 1.61. Coincidentally, the more well-known [Golden Ratio](https://en.wikipedia.org/wiki/Golden_ratio), $\phi = \frac{1+\sqrt{5}}{2} \approx 1.61$, has virtually the same value.

## Quick start

1. **Get the data** — [`docs/DATA.md`](docs/DATA.md): download the ALMRRC dataset.
2. **Set up routing** — [`docs/OSRM.md`](docs/OSRM.md): either
   - download OpenStreetMap extracts from Geofabrik and process them with Docker, or
   - download the ~15 GB pre-processed OSRM graphs directly (link in that doc).
3. **Run the notebook** — [`notebooks/compute_ratio.ipynb`](notebooks/compute_ratio.ipynb):
   set `data_dir`, run all cells, read the ratio at the bottom.

## Requirements

- Python 3.9+ with `numpy`, `pandas`, `requests`, `jupyter` (see `requirements.txt`)
- Docker Desktop / Docker Engine
- ~5–15 GB free disk depending on how many metros you route

### Setting up the Python environment

**Linux / macOS**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
jupyter notebook notebooks/compute_ratio.ipynb
```

**Windows (PowerShell)**
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
jupyter notebook notebooks\compute_ratio.ipynb
```

> If PowerShell blocks the activation script, allow it for the current user once with
> `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, then re-run the activate line.

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
│   ├── run_servers.sh         # launch one OSRM server per metro (Linux/macOS)
│   └── run_servers.ps1        # same, for Windows PowerShell
└── notebooks/
    └── compute_ratio.ipynb   # main analysis -> single ratio
```

## Citing this work

If you use this repository, please cite it as:

    @misc{gerrits_2026_goldenratio,
      author       = {Gerrits, Berry},
      title        = {The Ratio Between Real and Euclidean Distance},
      year         = {2026},
      howpublished = {\url{https://github.com/berrygerrits/amazon-euclidean-real-ratio}}
    }

Please also cite the underlying dataset:

    @article{merchan_2022_almrrc,
      author  = {Merch{\'a}n, Daniel and Arora, Jatin and Pachon, Joseph and
                 Konduri, Karthik and Winkenbach, Matthias and Parks, Steven and
                 Noszek, Joseph},
      title   = {2021 {Amazon} Last Mile Routing Research Challenge: Data Set},
      journal = {Transportation Science},
      year    = {2022},
      volume  = {58},
      number  = {1},
      pages   = {8--11},
      doi     = {10.1287/trsc.2022.1173}
    }

## License

Code released under the MIT License. The Amazon dataset is governed separately by
its own CC BY-NC 4.0 license — see `docs/DATA.md`.
