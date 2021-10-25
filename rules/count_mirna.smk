
rule umi_dedup:
    input:
       bam="reads/aligned/{sample}.mirna.bam",
       bai="reads/aligned/{sample}.mirna.bam.bai"
    output:
        "reads/dedup/{sample}.mirna_dedup.bam"
    conda:
        "../envs/umi_tools.yaml"
    log:
        "logs/umi_tools/{sample}_deduplication.log"
    shell:
        "umi_tools dedup "
        "-I {input.bam} "
        "-S {output} "
        "--method=unique "
        "--log={log} "


rule samtools_count:

    input:
        bam="reads/dedup/{sample}.mirna_dedup.bam",
        bai="reads/dedup/{sample}.mirna_dedup.bam.bai"
    output:
        counts="reads/counts/{sample}.mirna.txt"
    conda:
        "../envs/samtools.yaml"
    benchmark:
        "benchmarks/samtools/count/{sample}.txt"
    params:
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta"))
    threads: conservative_cpu_count(reserve_cores=2, max_cores=99)
    shell:
        "samtools idxstats {input.bam} | cut -f 1,3 "
        "> {output.counts} "


rule htseq:
    input:
        bam="reads/dedup/{sample}.mirna_dedup.bam",
        bai="reads/dedup/{sample}.mirna_dedup.bam.bai",
        gff=config.get("htseq_gff")
    output:
        counts="htseq/{sample}.counts"
    params:
        params=config.get("rules").get("htseq").get("params")
    conda:
        "../envs/htseq.yaml"
    shell:
        "htseq-count "
        "params"
        "-q {input.bam} "
        "{input.gff} "
        ">{output.counts}"