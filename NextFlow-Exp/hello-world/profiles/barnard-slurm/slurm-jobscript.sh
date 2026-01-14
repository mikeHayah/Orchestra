#!/bin/bash -l
#SBATCH -J {rule}
#SBATCH --account={resources.account}
#SBATCH --time={{ '%02d:%02d:00' % (resources.runtime // 60, resources.runtime % 60) if resources.runtime else '01:00:00' }}
#SBATCH --partition={resources.partition}
#SBATCH --cpus-per-task={resources.cpus}    
#SBATCH --mem={resources.mem_mb}M
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2

#SBATCH -o check-log.out
#SBATCH -e check-log.err
#SBATCH --mail-type=all
#SBATCH --mail-user=michael_gamal_nassif.hanna@mailbox.tu-dresden.de

echo "Running job for your rule: {rule}"

{exec_job}
