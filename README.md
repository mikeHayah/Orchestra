# Orchestra 🎼

A bash script for orchestrating alternating job submissions across multiple HPC clusters at TU Dresden.

## Overview

Orchestra automates the process of submitting and monitoring SLURM jobs across two HPC clusters (Alpha and Barnard). It runs an initial job, then alternates between backward and forward jobs across the clusters for a specified number of iterations.

## Prerequisites

- SSH access to TU Dresden HPC clusters (Alpha and Barnard)
- SSH key authentication configured for both clusters
- Git Bash (if running on Windows)
- Active experiment directory on the cluster at:  `/data/horse/ws/miha493e-research_project/activediffusion/actdiff_experiments/`

## Configuration

Before running the script, edit `orchestra.sh` and update the following variables:

```bash
loginid="xxxxxxxx"        # Your TU Dresden login ID
exp="test"                # Your experiment directory name
n_iterations=9            # Number of alternating iterations (default: 9)
sleep_interval=1200       # Time between job status checks in seconds (default: 20 minutes)
```

### Job Scripts

The script expects the following SLURM job scripts in your experiment directory: 
- `init-actdiff_c.sh` - Initial job (runs on Alpha)
- `backward-actdiff_b.sh` - Backward job (runs on Barnard)
- `forward-actdiff_c.sh` - Forward job (runs on Alpha)

## Installation & Usage

### On Windows (Using Git Bash)

1. **Clone the repository:**
   ```bash
   git clone git@github.com:mikeHayah/Orchestra.git
   cd Orchestra
   ```

2. **Set up SSH authentication:**
   - Copy your SSH key to both clusters if you haven't already: 
     ```bash
     ssh-copy-id <loginid>@login2.alpha.hpc.tu-dresden.de
     ssh-copy-id <loginid>@login2.barnard.hpc.tu-dresden.de
     ```

3. **Configure the script:**
   - Edit `orchestra.sh` and update `loginid` and `exp` variables
   - Optionally adjust `n_iterations` and `sleep_interval`

4. **Make the script executable:**
   ```bash
   chmod +x orchestra.sh
   ```

5. **Run the orchestration:**
   ```bash
   ./orchestra.sh
   ```

### On Linux/macOS

Follow the same steps as Windows, using your terminal instead of Git Bash.

## How It Works

1. **Initial Job**: Submits the initial job (`init-actdiff_c. sh`) on the Alpha cluster
2. **Alternating Loop**: For each iteration:
   - Submits backward job (`backward-actdiff_b.sh`) on Barnard
   - Waits for completion
   - Submits forward job (`forward-actdiff_c.sh`) on Alpha
   - Waits for completion
3. **Monitoring**: The script continuously checks job status and waits for completion before proceeding
4. **Error Handling**: Exits immediately if any job fails, is cancelled, or times out

## Job Status Monitoring

The script checks job status every `sleep_interval` seconds (default: 20 minutes). It recognizes the following states:
- **COMPLETED**: Job finished successfully, proceeds to next step
- **FAILED/CANCELLED/TIMEOUT**: Job failed, script exits with error

## Troubleshooting

- **SSH connection issues**: Ensure your SSH keys are properly configured and you can manually SSH into both clusters
- **Job script not found**:  Verify that all job scripts exist in your experiment directory on the cluster
- **Permission denied**: Make sure `orchestra.sh` is executable (`chmod +x orchestra.sh`)
- **Job failures**: Check SLURM output logs in your experiment directory for details

## Nextflow Experiments

This repository also includes Nextflow workflow experiments for alternative orchestration approaches.  See the [NextFlow-Exp folder](NextFlow-Exp/) for details. 

## License

MIT

## Author

[@mikeHayah](https://github.com/mikeHayah)
