#!/bin/bash

# ********************************************************
#--- slurm commands ---
# ********************************************************

#SBATCH -J NanoBCF
#SBATCH --partition=longrun
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kkariuki@kemri-wellcome.org      # replace with your email address

# ********************************************************
# activate conda environment
# ********************************************************

source "${HOME}/miniforge3/etc/profile.d/conda.sh"
conda activate snakemake8

# ********************************************************
#--- snakemake commands ---
# ********************************************************
snakemake --unlock

snakemake \
	--use-conda \
	--conda-frontend mamba \
	--software-deployment-method conda \
	--cores 4 \
	--jobs 1 \
	--rerun-incomplete

# ********************************************************
#--- end ---
# ********************************************************
conda deactivate
