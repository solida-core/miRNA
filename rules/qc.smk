rule fastqc:
    input:
        lambda wildcards: get_fastq(wildcards, samples, read_pair="fq1")
#        "reads/untrimmed/{sample}.fastq.gz"
    output:
        html="qc/fastqc/untrimmed_{sample}.html",
        zip="qc/fastqc/untrimmed_{sample}_fastqc.zip"
    log:
        "logs/fastqc/untrimmed/{sample}.log"
    params:
        outdir="qc/fastqc"
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc "
        "{input} "
        "--outdir {params.outdir} "
        "--quiet "
        ">& {log}"


rule fastqc_umi_extract:
    input:
        "reads/umi_extract/{sample}_umi.fastq.gz"
    output:
        html="qc/fastqc/{sample}_umi_fastqc.html",
        zip="qc/fastqc/{sample}_umi_fastqc.zip"
    log:
        "logs/fastqc/umi/{sample}.log"
    params:
        outdir="qc/fastqc"
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc "
        "{input} "
        "--outdir {params.outdir} "
        "--quiet "
        ">& {log}"


rule fastqc_trimmed:
    input:
        "reads/trimmed/{sample}-trimmed.fq"
    output:
        html="qc/fastqc/{sample}-trimmed_fastqc.html",
        zip="qc/fastqc/{sample}-trimmed_fastqc.zip"
    log:
        "logs/fastqc/trimmed/{sample}.log"
    params:
        outdir="qc/fastqc"
    conda:
        "../envs/fastqc.yaml"
    shell:
        "fastqc "
        "{input} "
        "--outdir {params.outdir} "
        "--quiet "
        ">& {log}"


rule mirtrace:
    input:
        "reads/trimmed/{sample}-trimmed.fq"
    output:
        "mir_trace/{sample}/mirtrace-results.json",
        "mir_trace/{sample}/mirtrace-stats-length.tsv",
        "mir_trace/{sample}/mirtrace-stats-contamination_basic.tsv",
        "mir_trace/{sample}/mirtrace-stats-mirna-complexity.tsv"
    conda:
        "../envs/mirtrace.yaml"
    params:
        outdir="mir_trace/{sample}",
        params="--force",
        species=config.get("rules").get("mir_trace").get("params")
    log:
        "logs/mirtrace/{sample}.mirtrace_qc.log"
    shell:
        "mirtrace "
        "qc "
        "{params.species} "
        "-o {params.outdir} "
        "{input} "
        "{params.params} "
        ">& {log} "


rule multiqc:
    input:
#        expand("qc/fastqc/untrimmed_{sample.sample}_fastqc.zip", sample=samples.reset_index().itertuples()),
        expand("qc/fastqc/{sample.sample}_umi_fastqc.zip", sample=samples.reset_index().itertuples()),
        expand("qc/fastqc/{sample.sample}-trimmed_fastqc.zip", sample=samples.reset_index().itertuples()),
        expand("reads/trimmed/{sample.sample}.fastq.gz_trimming_report.txt", sample=samples.reset_index().itertuples()),
        expand("mir_trace/{sample.sample}/mirtrace-results.json", sample=samples.reset_index().itertuples()),
        expand("mir_trace/{sample.sample}/mirtrace-stats-length.tsv", sample=samples.reset_index().itertuples()),
        expand("mir_trace/{sample.sample}/mirtrace-stats-contamination_basic.tsv", sample=samples.reset_index().itertuples()),
        expand("mir_trace/{sample.sample}/mirtrace-stats-mirna-complexity.tsv", sample=samples.reset_index().itertuples()),
#        expand("htseq/{sample.sample}.counts", sample=samples.reset_index().itertuples())

    output:
        report("qc/multiqc.html",caption="../report/multiqc.rst", category="QC")
    params:
        params=config.get("rules").get("multiqc").get("arguments"),
        outdir="qc",
        outname="multiqc.html",
        fastqc="qc/fastqc/",
        trimming="reads/trimmed/",
        reheader=config.get("reheader")
    conda:
        "../envs/multiqc.yaml"
    log:
        "logs/multiqc/multiqc.log"
    shell:
        "multiqc "
        "{input} "
        "{params.fastqc} "
        "{params.trimming} "
        "{params.params} "
        "-o {params.outdir} "
        "-n {params.outname} "
        "--sample-names {params.reheader} "
        ">& {log}"