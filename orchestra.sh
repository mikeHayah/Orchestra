#!/usr/bin/env bash
set -euo pipefail

# Please set your login ID and experiment directory here
loginid="xxxxxxxx"
exp="test"
n_iterations=9     # Number of alternating iterations
sleep_interval=1200  # Time to wait between job status checks (in seconds) 

# Define hosts 
ALPHA_HOST="$loginid@login2.alpha.hpc.tu-dresden.de"
BARNARD_HOST="$loginid@login2.barnard.hpc.tu-dresden.de"
# Define job scripts
INTIAL_JOB="init-actdiff_c.sh"
BARNARD_JOB="backward-actdiff_b.sh"
ALPHA_JOB="forward-actdiff_c.sh"


# Function to submit a job and return the job ID
submit_job() {
    local host="$1"
    local script="$2"
    ssh "$host" "cd /data/horse/ws/miha493e-research_project/activediffusion/actdiff_experiments/$exp && sbatch $script" | awk '{print $4}'
}
# Function to wait for a job to complete
wait_for_job() {
    local host="$1"
    local jobid="$2"

    while true; do
        status=$(ssh "$host" "sacct -j ${jobid}.batch --format=State --noheader" | awk '{print $1}')
        case "$status" in
            COMPLETED*) return 0 ;;
            FAILED*|CANCELLED*|TIMEOUT*) return 1 ;;
        esac
        echo "Job $jobid on $host is still running. Checking again in $sleep_interval seconds..."
        echo "Current status: $status"
        sleep $sleep_interval
    done
}


# Main orchestration loop
# -----------------------------------
# intial job submission
echo "=== Iteration 0 ==="
echo "Submitting Intial job on alpha..."
jid=$(submit_job "$ALPHA_HOST" "$INTIAL_JOB")
wait_for_job "$ALPHA_HOST" "$jid"

# Start the alternating job submissions
for ((i=1; i<=n_iterations; i++)); do
    
    echo "Submitting backward job on barnard..."
    jid=$(submit_job "$BARNARD_HOST" "$BARNARD_JOB")
    wait_for_job "$BARNARD_HOST" "$jid" || { echo "Backward job failed"; exit 1; }

    echo "=== Iteration $i ==="

    echo "Submitting forward job on alpha..."
    jid=$(submit_job "$ALPHA_HOST" "$ALPHA_JOB")
    wait_for_job "$ALPHA_HOST" "$jid" || { echo "Forward job failed"; exit 1; }

done
