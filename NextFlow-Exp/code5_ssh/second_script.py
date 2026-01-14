import sys
import os

cpus_per_task = int(os.environ.get("SLURM_CPUS_PER_TASK", 1))
ntasks = int(os.environ.get("SLURM_NTASKS", 1))


with open(sys.argv[1], "r") as f:
    content = f.read()

with open('output2.txt', "w") as f:
    # f.write(f"From first script: {content}\n")
    f.write("Second script Nextflow + Python on SLURM!\n")
    f.write(f"CPUs per task: {cpus_per_task}\n")
    f.write(f"Number of tasks: {ntasks}\n")

    
 