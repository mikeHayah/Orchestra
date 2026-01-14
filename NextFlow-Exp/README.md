# Nextflow Experiments

A collection of progressive Nextflow experiments exploring workflow orchestration for HPC clusters at TU Dresden.  These experiments build upon each other, starting from basic workflows and advancing to SSH-based cross-cluster job submission.

## Overview

This directory contains learning experiments that explore Nextflow's capabilities for workflow orchestration, with a focus on SLURM-based HPC environments. The experiments progress from simple "hello world" workflows to complex multi-cluster job orchestration patterns.

## Prerequisites

- Nextflow installed (via conda or standalone)
- SSH access to TU Dresden HPC clusters (Alpha and Barnard)
- Conda environment with dependencies

### Environment Setup

Create the conda environment with all required dependencies:

```bash
conda env create -f environment.yml
conda activate env-nextflow
```

The environment includes:
- Python 3.12
- Nextflow
- Scientific computing libraries (pandas, scikit-learn, matplotlib, numpy)

## Experiments

### code0_hello
**Basic Hello World**

A minimal Nextflow workflow to verify installation and basic functionality. 

- **Purpose**: Introduction to Nextflow DSL2 syntax
- **Key concepts**: Simple process definition, workflow execution
- **Run**: 
  ```bash
  cd code0_hello
  nextflow run main.nf
  ```

---

### code1_2process
**Two-Process Pipeline**

Demonstrates a workflow with two sequential processes, passing data between them.

- **Purpose**: Learn process chaining and data flow
- **Key concepts**: Input/output channels, process dependencies
- **Scripts**:  
  - `first_script.py`: Initial data processing
  - `second_script.py`: Consumes output from first process
- **Run**:
  ```bash
  cd code1_2process
  nextflow run main. nf
  ```

---

### code2_loop
**Iterative Workflow**

Introduces looping/iteration patterns in Nextflow workflows.

- **Purpose**: Explore iterative processing patterns
- **Key concepts**: Channel operators, iterative data processing
- **Scripts**:
  - `first_script.py`: Generates iterable data
  - `second_script.py`: Processes data in iterations
- **Run**:
  ```bash
  cd code2_loop
  nextflow run main. nf
  ```

---

### code3_completeloop
**Complete Iteration with Driver**

A complete iterative workflow with external driver script control.

- **Purpose**: Full iteration lifecycle with workflow orchestration
- **Key concepts**: External workflow control, state management
- **Scripts**: 
  - `driver. sh`: Controls workflow execution
  - `first_script.py`: Initialization and iteration logic
  - `second_script.py`: Iteration processing
  - `empty. txt`: Placeholder file for workflow inputs
- **Run**:
  ```bash
  cd code3_completeloop
  ./driver.sh
  ```

---

### code4_diffResources
**Different Resource Allocations**

Demonstrates how to assign different computational resources to different processes.

- **Purpose**: Learn resource management and process labels
- **Key concepts**: 
  - Process labels (`light_job`, `heavy_job`)
  - SLURM resource configuration
  - Queue and partition selection
- **Configuration highlights**:
  ```nextflow
  withLabel: light_job {
      clusterOptions = '--ntasks=8 --cpus-per-task=2'
  }
  withLabel: heavy_job {
      clusterOptions = '--ntasks=1 --cpus-per-task=8'
  }
  ```
- **Run**:
  ```bash
  cd code4_diffResources
  nextflow run main.nf
  ```

---

### code5_ssh
**SSH-Based Cross-Cluster Submission** 

The most advanced experiment:  submitting SLURM jobs to remote HPC clusters via SSH from a Nextflow workflow.

- **Purpose**: Remote job submission and cross-cluster orchestration
- **Key concepts**:
  - SSH execution from Nextflow processes
  - Remote SLURM job submission
  - Heredoc syntax for complex scripts
  - Cross-cluster workflow patterns
- **Workflow**:
  1. SSH to remote cluster (Alpha)
  2. Create remote working directory
  3. Copy Python script via SCP
  4. Generate and submit SLURM job script
- **Configuration**:
  ```bash
  REMOTE_USER=miha493e
  REMOTE_HOST=login2.alpha.hpc.tu-dresden.de
  REMOTE_DIR=/home/$REMOTE_USER/test_job_dir
  ```
- **Run**:
  ```bash
  cd code5_ssh
  nextflow run main.nf
  ```

**Note**: Update `REMOTE_USER` in `main.nf` with your credentials before running.

## Common Patterns

### Running Workflows

All experiments use Nextflow DSL2 syntax: 
```bash
cd <experiment_directory>
nextflow run main.nf
```

### Cleaning Up

Remove Nextflow work directories and cache:
```bash
nextflow clean -f
# or manually
rm -rf work/ . nextflow/ . nextflow. log*
```

### Debugging

Enable detailed logging: 
```bash
nextflow run main.nf -with-trace -with-report -with-timeline
```

## HPC Configuration Notes

These experiments target TU Dresden HPC infrastructure:
- **Alpha cluster**: Primary compute cluster
- **Barnard cluster**:  Secondary compute cluster
- **Account**: `p_nanoparticle`
- **Partitions**: `alpha`, `barnard`, `default`

### Typical SLURM Options Used

```bash
#SBATCH --account=p_nanoparticle
#SBATCH --partition=alpha|barnard
#SBATCH --time=00:05:00
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1-8
#SBATCH --nodes=1
```

## Progression Path

Recommended learning order: 

1. **code0_hello** → Basic Nextflow syntax
2. **code1_2process** → Process chaining
3. **code2_loop** → Iteration patterns
4. **code3_completeloop** → Full workflow orchestration
5. **code4_diffResources** → Resource management
6. **code5_ssh** → Advanced cross-cluster patterns

## Troubleshooting

### Common Issues

**SSH authentication failures**:
```bash
# Ensure SSH keys are configured
ssh-copy-id <user>@login2.alpha.hpc.tu-dresden.de
```

**Nextflow executor errors**:
- Check SLURM queue availability:  `squeue -u $USER`
- Verify partition access: `sinfo`

**Process failures**:
- Check work directory logs: `cat work/<hash>/. command.log`
- Review SLURM output files: `job_output.txt`, `job_error.txt`

## Related Resources

- [Nextflow Documentation](https://www.nextflow.io/docs/latest/)
- [Nextflow Patterns](https://nextflow-io.github.io/patterns/)
- [TU Dresden HPC Documentation](https://doc.zih.tu-dresden.de/)
- Main Orchestra script: [`../orchestra. sh`](../orchestra.sh)

## Future Directions

Potential extensions of these experiments: 

- Basic workflow execution
- Process chaining and iteration
- Resource allocation
- SSH-based remote submission
- Multi-cluster alternating patterns (Alpha ↔ Barnard)
- Automated job monitoring and recovery
- Integration with main Orchestra bash script
- Container-based execution with Singularity

## Author

[@mikeHayah](https://github.com/mikeHayah)

## License

MIT
