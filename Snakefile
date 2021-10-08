import pandas as pd
# from snakemake.utils import validate, min_version

## USER FILES ##
samples = pd.read_csv(config["samples"], index_col="sample", sep="\t")
units = pd.read_csv(config["units"], index_col=["unit"], dtype=str, sep="\t")
reheader = pd.read_csv(config["reheader"],index_col="Client", dtype=str, sep="\t")
reheader = reheader[reheader["LIMS"].isin(samples.index.values)]
## ---------- ##


##### local rules #####
localrules: all, pre_rename_fastq_se, post_rename_fastq_se

rule all:
    input:
        "qc/multiqc.html"
        # expand("htseq/{sample.sample}.counts", sample=samples.reset_index().itertuples())


### rules inclusion
include_prefix="rules"
include:
    include_prefix + "/functions.py"
include:
    include_prefix + "/qc.smk"
include:
    include_prefix + "/umi_and_trimming.smk"
include:
    include_prefix + "/mapping.smk"
include:
    include_prefix + "/htseq.smk"
# include:
#     include_prefix + "/discovering.smk"
