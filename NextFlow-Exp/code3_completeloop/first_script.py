import sys, os

prev_file = sys.argv[1]
iter_number = sys.argv[2] 
output_file = f"output1.txt"

if prev_file != "none" and os.path.exists(prev_file):
    with open(prev_file) as f:
        prev_content = f.read()
else:
    prev_content = ""

with open(output_file, "w") as f:
    f.write(f"{prev_content}\n")
    f.write(f"First script Nextflow + Python on SLURM!{iter_number}\n")
    

