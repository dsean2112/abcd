#!/bin/bash

#SBATCH --comment=CARDIO_DARBAR
#SBATCH --job-name={{ job_name }} # job name
#SBATCH --array=1-{{ n_jobs }} # number of processes
#SBATCH --partition={{ queue | medium }} # name of queue
#SBATCH --qos={{ service | normal }} # which special QOS (short/long)
#SBATCH --time={{ walltime | 12:00:00 }} # walltime in hh:mm:ss
#SBATCH --cpus-per-task={{ n_cpu | 1 }} # set cores per task
#SBATCH --mem-per-cpu={{ mem_cpu | 1024 }} # set min memory per core
#SBATCH --nodes={{ nodes | 1 }} # if 1 put load on one node

printf 'Loading modules\n'
module load R/4.1.2-foss-2021b Anaconda3/2022.05
module list