import sys

input_path = sys.argv[1]
output_file = f"output2_iter{sys.argv[2]}.txt"

print(f"Reading from {input_path}, writing to {output_file}")

with open(input_path, "r") as f:
    content = f.read()

with open(output_file, "w") as f:
    f.write(f"From first script: {content} {sys.argv[2]}\n")
    f.write("Second script Nextflow + Python on SLURM!\n")
   