def get_fastq(wildcards,samples,read_pair='fq'):
    return samples.loc[wildcards.sample,
                     [read_pair]].dropna()[0]

rule UMI_tools:
    input:
        lambda wildcards: get_fastq(wildcards, samples, read_pair="fq1")
    output:
        "reads/umi_extract/{sample}_umi.fastq.gz"
    conda:
        "../envs/umi_tools.yaml"
    log:
        "logs/umi_tools/{sample}_UMI_trimmed.log"
    shell:
        "umi_tools extract "
        "--stdin={input} "
        "--stdout={output} "
        "--log={log} "
        "--extract-method=regex "
        "--bc-pattern='.+(?P<discard_1>AACTGTAGGCACCATCAAT)"
        "{{s<=2}}"
        "(?P<umi_1>.{{12}})(?P<discard_2>.*)'"


rule pre_rename_fastq_se:
    input:
        r1="reads/umi_extract/{sample}_umi.fastq.gz"
    output:
        r1="reads/untrimmed/{sample}.fastq.gz"
    shell:
        "ln -s {input.r1} {output.r1}"


rule trim_galore_se:
    input:
        "reads/untrimmed/{sample}.fastq.gz"
    output:
        "reads/trimmed/{sample}_trimmed.fq",
        "reads/trimmed/{sample}.fastq.gz_trimming_report.txt"
    params:
        extra=config.get("rules").get("trim_galore_se").get("arguments"),
        outdir="reads/trimmed/"
    log:
        "logs/trim_galore/{sample}.log"
    benchmark:
        "benchmarks/trim_galore/{sample}.txt"
    conda:
        "../envs/trim_galore.yaml"
    threads: (conservative_cpu_count(reserve_cores=2, max_cores=99))/2 if (conservative_cpu_count(reserve_cores=2, max_cores=99)) >2 else 1
    shell:
        "mkdir -p qc/fastqc; "
        "trim_galore "
        "{params.extra} "
        "--cores {threads} "
        "-o {params.outdir} "
        "{input} "
        ">& {log}"


rule post_rename_fastq_se:
    input:
        rules.trim_galore_se.output
    output:
        r1="reads/trimmed/{sample}-trimmed.fq"
    shell:
        "mv {input[0]} {output.r1} "


