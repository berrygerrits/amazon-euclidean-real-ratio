# Getting the Amazon Last Mile Routing Research Challenge dataset

The dataset contains 9,184 historical routes driven by Amazon drivers in 2018
across five US metros (Seattle, Los Angeles, Austin, Chicago, Boston), with
route-, stop-, and package-level features.

## License

The material is provided under a **Creative Commons Attribution-NonCommercial 4.0
International (CC BY-NC 4.0)** license. Non-commercial use only. Full terms:
https://creativecommons.org/licenses/by-nc/4.0/legalcode.txt

## Download

The dataset is hosted on the AWS Registry of Open Data:

- Landing page: https://registry.opendata.aws/amazon-last-mile-challenges/
- Formal description (Transportation Science):
  https://pubsonline.informs.org/doi/10.1287/trsc.2022.1173

### Install the AWS CLI (once)

No AWS account or credentials are needed — the bucket is public and every command
below uses `--no-sign-request`.

- **Linux / macOS**: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
  (on macOS you can also use `brew install awscli`)
- **Windows**: download and run the MSI installer from
  https://awscli.amazonaws.com/AWSCLIV2.msi

Verify it's on your PATH:

**Linux / macOS**
```bash
aws --version
```
**Windows (PowerShell)**
```powershell
aws --version
```

### Download the data

The training portion (6,112 routes) is what the notebook uses; the evaluation
portion is optional.

**Linux / macOS**
```bash
mkdir -p data && cd data

# Training portion (6,112 routes)
aws s3 sync --no-sign-request \
  s3://amazon-last-mile-challenges/almrrc2021/almrrc2021-data-training/ \
  ./almrrc2021-data-training/

# (Optional) evaluation portion (3,072 routes)
aws s3 sync --no-sign-request \
  s3://amazon-last-mile-challenges/almrrc2021/almrrc2021-data-evaluation/ \
  ./almrrc2021-data-evaluation/
```

**Windows (PowerShell)** — note the backtick (`` ` ``) is PowerShell's
line-continuation character:
```powershell
New-Item -ItemType Directory -Force data | Out-Null
Set-Location data

# Training portion (6,112 routes)
aws s3 sync --no-sign-request s3://amazon-last-mile-challenges/almrrc2021/almrrc2021-data-training/ almrrc2021-data-training

# (Optional) evaluation portion (3,072 routes)
aws s3 sync --no-sign-request s3://amazon-last-mile-challenges/almrrc2021/almrrc2021-data-evaluation/ almrrc2021-data-training
```

## What's inside

The training folder contains the JSON files the notebook's loader expects:

```
almrrc2021-data-training/
└── model_build_inputs/
    ├── route_data.json         # per-route metadata + stops (lat/lng, type, zone)
    ├── package_data.json       # packages per stop
    ├── actual_sequences.json   # the driver's route
    └── travel_times.json       # travel times (not needed for our purposes)
```

Distances are computed along the route that was actually driven using the `actual_sequences.json` file

## Data structure reference

https://github.com/MIT-CAVE/rc-cli/blob/main/templates/data_structures.md

## Where to put it

Point the notebook's `data_dir` at the `model_build_inputs/` folder. Use the path
style for your OS:

- **Linux / macOS**: `data_dir = "./almrrc2021-data-training/model_build_inputs"`
- **Windows**: `data_dir = r".\almrrc2021-data-training\model_build_inputs"`
  (the leading `r` makes it a raw string so backslashes aren't treated as escapes),
  or simply use forward slashes, which Python accepts on Windows too:
  `data_dir = "./almrrc2021-data-training/model_build_inputs"`

Anywhere on disk is fine as long as that path points at the `model_build_inputs`
folder.
