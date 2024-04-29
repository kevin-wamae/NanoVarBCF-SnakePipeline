#!/bin/bash

# ********************************************************
#--- slurm commands ---
# ********************************************************

#SBATCH -J NanoBCF
#SBATCH --partition=longrun
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=2
#SBATCH --mem=100G
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<>       # replace with your email address

# ********************************************************
# activate conda environment
# ********************************************************

source "${HOME}/miniforge3/etc/profile.d/conda.sh"
conda activate snakemakeVersion7

# ********************************************************
#--- snakemake commands ---
# ********************************************************
snakemake --unlock

snakemake \
	--use-conda \
	--conda-frontend mamba \
	--use-singularity \
	--cores 8 \
	--jobs 4 \
	--rerun-incomplete

# ********************************************************
#--- end ---
# ********************************************************
conda deactivate
