import os
import sys

cpus_per_task = int(os.environ.get("SLURM_CPUS_PER_TASK", 1))
ntasks = int(os.environ.get("SLURM_NTASKS", 1))

with open('output1.txt', "w") as f:
    f.write("First script Nextflow + Python on SLURM!\n")
    f.write(f"CPUs per task: {cpus_per_task}\n")
    f.write(f"Number of tasks: {ntasks}\n")

