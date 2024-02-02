#!/bin/bash

# ********************************************************
#--- slurm commands ---
# ********************************************************

#SBATCH -J NanoRave
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<email>

# ********************************************************
# activate conda environment
# ********************************************************

source "${HOME}/mambaforge/etc/profile.d/conda.sh"
conda activate snakemake

# ********************************************************
#--- snakemake commands ---
# ********************************************************
snakemake --unlock

snakemake \
	--use-conda \
	--conda-frontend mamba \
	--use-singularity \
	--cores 2 \
	--jobs 2 \
	--rerun-incomplete \
	--quiet all \
	--keep-going

# ********************************************************
#--- end ---
# ********************************************************
conda deactivate
