import sys

with open(sys.argv[1], "r") as f:
    content = f.read()

with open('output2.txt', "w") as f:
    f.write(f"From first script: {content}\n")
    f.write("Second script Nextflow + Python on SLURM!\n")
    
 