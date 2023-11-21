import sys
import re

input_vcf_path = sys.argv[1]
output_vcf_path = sys.argv[2]

# Read the content of the original VCF file into memory
with open(input_vcf_path, 'r') as vcf_in:
    lines = vcf_in.readlines()

# Open the original VCF file to write the modified data
with open(input_vcf_path, 'r') as vcf_in, open(output_vcf_path, 'w') as vcf_out:
    for line in vcf_in:
        # Write the header lines as is
        if line.startswith('#'):
            # If this is the line with FORMAT fields, add DP and AD definitions before the first format line
            if line.startswith('##FORMAT=<ID=GT'):
                vcf_out.write('##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Depth of reads at pos">\n')
                vcf_out.write('##FORMAT=<ID=AD,Number=R,Type=Integer,Description="Allelic depths for each ALT allele, in the same order as listed">\n')
            vcf_out.write(line)
        else:
            # Split the non-header line into its components
            chrom, pos, id, ref, alt, qual, filter, info, format, sample = line.strip().split('\t')

            # Extract the DP (read depth) from the INFO field
            dp_match = re.search(r'DP=(\d+)', info)
            dp = dp_match.group(1) if dp_match else '.'

            # Extract SR (spanning reads) from the INFO field and calculate the allelic depths
            sr_match = re.search(r'SR=([\d,]+)', info)
            if sr_match:
                sr_values = sr_match.group(1).split(',')
                ad_values = [str(sum(map(int, sr_values[i:i+2]))) for i in range(0, len(sr_values), 2)]
                ad = ','.join(ad_values)
            else:
                ad = '.'

            # Append the DP and AD to the FORMAT and SAMPLE columns
            new_format = format + ':DP:AD'
            new_sample = sample + f':{dp}:{ad}'

            # Write the modified line to the VCF file
            vcf_out.write('\t'.join([chrom, pos, id, ref, alt, qual, filter, info, new_format, new_sample]) + '\n')

