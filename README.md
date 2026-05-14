# Trivy Enterprise Image Scanner

A production-ready Bash automation framework for scanning container images using Trivy.

The scanner supports:

- Docker images already pulled locally
- Docker image TAR files (`*.tar`)
- Automatic import of TAR files from shared folders (e.g. `/media/Documents/`)

It performs comprehensive security analysis for:

- Vulnerabilities
- Secrets
- Misconfigurations

And generates enterprise-ready reports in:

- JSON
- Detailed CSV
- Executive Summary CSV
- Optional HTML
- ZIP archives

---

## Features

- Scans Docker images already pulled locally
- Scans Docker image TAR files from `images/`
- Automatically imports TAR files from an external directory
- Interactive numbered menu for image selection
- Option `1) Scan ALL images`
- Bulk scanning via `--all`
- Cleanup mode via `--cleanup`
- Severity override via `--severity`
- Quiet Trivy execution
- Report overwrite (latest scan replaces previous reports)
- Detailed enterprise CSV reports
- Executive Summary CSV
- Optional HTML reports using Trivy templates
- ZIP packaging of all artifacts
- Logging to `scan.log`
- CI/CD-friendly exit codes
- Fully configurable through `config.sh`

---

## Supported Severity Levels

- CRITICAL
- HIGH
- MEDIUM
- LOW

Default configuration:

```bash
SEVERITIES="CRITICAL,HIGH,MEDIUM,LOW"
```

---

## Project Structure

```text
~/Documents/docker-projects/trivy-enterprise-scanner/
├── trivy-scan
├── config.sh
├── README.md
├── CHANGELOG.md
├── .gitignore
├── images/
│   └── *.tar
├── reports/
│   └── <image-name>/
│       ├── <image-name>.json
│       ├── <image-name>.csv
│       ├── <image-name>-summary.csv
│       ├── <image-name>.html
│       └── <image-name>.zip
└── scan.log
```

---

## Requirements

Install required dependencies:

```bash
sudo apt update && sudo apt install -y trivy jq zip docker.io
```

---

## Docker Permissions
-
To enable scanning of Docker images already pulled locally, add your user to the Docker group:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Verify access:

```bash
docker images
```

---

## Installation

### Clone from GitHub

```bash
git clone https://github.com/wambuasammy/trivy-enterprise-scanner.git
cd trivy-enterprise-scanner
chmod +x trivy-scan
```

### Or Download as ZIP

1. Open your GitHub repository.
2. Click **Code** → **Download ZIP**.
3. Extract the archive.
4. Open a terminal in the extracted directory.
5. Run:

```bash
chmod +x trivy-scan
```

---

## Quick Setup

Create the project structure manually:

```bash
mkdir -p ~/Documents/docker-projects/trivy-enterprise-scanner/{images,reports} && \
cd ~/Documents/docker-projects/trivy-enterprise-scanner && \
touch trivy-scan config.sh README.md CHANGELOG.md LICENSE .gitignore && \
chmod +x trivy-scan
```

---

## Configuration

All settings are stored in `config.sh`.

### Key Configuration Options

| Setting | Description |
|--------|-------------|
| `BASE_DIR` | Root project directory |
| `IMAGES_DIR` | Directory containing Docker image TAR files |
| `IMPORT_DIR` | Optional external directory for automatic TAR import |
| `REPORTS_DIR` | Root directory for generated reports |
| `SCANNERS` | Trivy scanners to enable |
| `SEVERITIES` | Severity levels to include |
| `IGNORE_UNFIXED` | Exclude findings without available fixes |
| `HTML_TEMPLATE` | Optional HTML template path |

---

## Usage

### Interactive Scan

```bash
cd ~/Documents/docker-projects/trivy-enterprise-scanner
./trivy-scan
```

### Scan All Images

```bash
./trivy-scan --all
```

### Remove TAR Files After Successful Scan

```bash
./trivy-scan --cleanup
```

### Override Severity Levels

```bash
./trivy-scan --severity CRITICAL
./trivy-scan --severity HIGH,CRITICAL
./trivy-scan --severity CRITICAL,HIGH,MEDIUM,LOW
```

### Show Help

```bash
./trivy-scan --help
```

---

## Interactive Menu Example

```text
==============================================================
 Available Docker Images to Scan
==============================================================
 1) Scan ALL images
 2) docker:flask-lab:v1
 3) docker:nginx:latest
 4) tar:portal.tar
==============================================================
Select image number:
```

---

## Importing TAR Files Automatically

If the configured `IMPORT_DIR` (default: `/media/Documents/`) contains `.tar` files, the script automatically copies them into `images/`.

This is useful when:

- Pulling Docker images on Windows
- Saving them to a shared folder
- Accessing them from a Kali Linux virtual machine

---



## Example Workflow

```bash
# Pull image directly into Docker
docker pull nginx:latest

# Or save an image to TAR
docker save -o images/nginx.tar nginx:latest

# Run the scanner
./trivy-scan

# View generated reports
ls -lh reports/nginx/
```

---

## Report Types

### JSON Report

Raw Trivy output.

### Detailed CSV Report

Includes:

- Finding Type
- Target
- Component Type
- Severity
- Finding ID (CVE, Rule ID, Secret Rule)
- Package
- Installed Version
- Fixed Version
- Title
- Reference URL
- Description

### Executive Summary CSV

Includes aggregated counts for:

- Critical findings
- High findings
- Medium findings
- Low findings
- Secrets
- Misconfigurations
- Total findings
- Scan date

### HTML Report

Generated only when an HTML template is configured.

### ZIP Package

Contains all generated artifacts for easy sharing and archival.

---

## Sample Output

```text
==============================================================
 Trivy Enterprise Image Scanner v1.0.0
==============================================================

==============================================================
 Available Docker Images to Scan
==============================================================
 1) Scan ALL images
 2) docker:flask-lab:v1
 3) portal.tar
==============================================================

Select image number: 1

==============================================================
 Scan Completed Successfully
==============================================================
Image       : portal.tar
Reports Dir : /home/ace/Documents/docker-projects/trivy-enterprise-scanner/reports/portal
==============================================================
```

---

## CI/CD Integration

The script returns exit code `10` when CRITICAL findings are detected, allowing pipelines to fail based on policy thresholds.

Compatible with:

- GitHub Actions
- GitLab CI/CD
- Jenkins

---

## Logging

All operations are recorded in:

```text
~/Documents/docker-projects/trivy-enterprise-scanner/scan.log
```



## Recommended Tools

- Trivy
- Docker
- jq
- ShellCheck
- Git

---

## Troubleshooting

### No Images Found

Ensure either:

- Docker images exist locally (`docker images`)
- TAR files are present in `images/`

### Missing Dependencies

```bash
sudo apt update && sudo apt install -y trivy jq zip docker.io
```

### Permission Denied When Accessing Docker

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Script Not Executable

```bash
chmod +x trivy-scan
```

---

## License

This project is intended for authorized security testing, DevSecOps, compliance, and container security assessments.

---

## Author

Created as a reusable container security automation framework powered by Trivy.