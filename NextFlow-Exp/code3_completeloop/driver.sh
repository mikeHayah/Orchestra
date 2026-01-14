#!/bin/bash

prev="empty.txt"  # Initial value for the previous output file
for i in {1..5}; do
    echo "Starting iteration $i with prev=$prev"
    nextflow run main.nf --iter $i --prev_output $prev
    prev="results/output2_iter${i}.txt"
done

# Make it executable: chmod +x driver.sh



