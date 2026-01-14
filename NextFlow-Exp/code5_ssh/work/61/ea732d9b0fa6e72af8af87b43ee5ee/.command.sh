#!/bin/bash -ue
REMOTE_USER=miha493e
REMOTE_HOST=login2.alpha.hpc.tu-dresden.de
REMOTE_DIR=/home/$REMOTE_USER/test_job_dir


# Create remote directory (ssh from local)
ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_DIR"

# Copy the script to remote directory (from local)
scp second_script.py $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/


ssh $REMOTE_USER@$REMOTE_HOST 'bash -s' <<EOF

cd $REMOTE_DIR 

cat > run_job.sh <<EOT
#!/bin/bash
#SBATCH --job-name=test_job
#SBATCH --partition=alpha
#SBATCH --time=00:05:00
#SBATCH --output=job_output.txt
#SBATCH --error=job_error.txt
#SBATCH -A p_nanoparticle
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

echo "Running on $(hostname)"

python3 "./second_script.py"

sleep 30
echo "Done"
EOT

sbatch run_job.sh
EOF
