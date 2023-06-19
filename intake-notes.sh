#!/bin/bash

#SBATCH --partition=cpu-t2
#SBATCH --qos=short
#SBATCH --nodes=8
#SBATCH --tasks-per-node=2
#SBATCH --cpus-per-task=2 		# Number of cores per task
#SBATCH --job-name=Notes
#SBATCH --error=Notes.%J.stderr
#SBATCH --output=Notes.%J.stdout

printf 'Loading modules\n'
module load R/4.1.2-foss-2021b Anaconda3/2022.05

printf 'Using R\n'
Rscript /shared/home/ashah282/projects/cbcd/R/intake-notes.R
