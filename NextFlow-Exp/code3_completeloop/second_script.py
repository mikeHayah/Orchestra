import sys

input_path = sys.argv[1]     # output1.txt
iter_number = sys.argv[2]
output_file = f"output2_iter{iter_number}.txt"

with open(input_path, "r") as f:
    content = f.read()

with open(output_file, "w") as f:
    f.write(content)
    f.write(f"[Second step - iter {iter_number}]\n")
