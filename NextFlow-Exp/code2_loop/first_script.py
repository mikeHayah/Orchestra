import sys

print(f"Writing output1.txt for iter {sys.argv[1]}")
with open('output1.txt', "w") as f:
    f.write(f"First script Nextflow + Python on SLURM!{sys.argv[1]}\n")

# wait 30 seconds
import time
time.sleep(30)