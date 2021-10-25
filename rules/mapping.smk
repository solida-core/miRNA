

rule mapping_miRBase_mature:
    input:
        "reads/trimmed/{sample}-trimmed.fq",
    output:
        sam="reads/aligned/{sample}.mirbase_mature.sam",
        fastq="reads/unaligned/{sample}.mirbase_mature.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_miRBase_hairpin:
    input:
        rules.mapping_miRBase_mature.output.fastq
    output:
        sam="reads/aligned/{sample}.mirbase_hairpin.sam",
        fastq="reads/unaligned/{sample}.mirbase_hairpin.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_piRNA:
    input:
        rules.mapping_miRBase_hairpin.output.fastq
    output:
        sam="reads/aligned/{sample}.piRNA.sam",
        fastq="reads/unaligned/{sample}.piRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_tRNA:
    input:
        rules.mapping_piRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.tRNA.sam",
        fastq="reads/unaligned/{sample}.tRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_rRNA:
    input:
        rules.mapping_tRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.rRNA.sam",
        fastq="reads/unaligned/{sample}.rRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_mRNA:
    input:
        rules.mapping_rRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.mRNA.sam",
        fastq="reads/unaligned/{sample}.mRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_other:
    input:
        rules.mapping_mRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.other_miRNA.sam",
        fastq="reads/unaligned/{sample}.other_miRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_miRBase_mature2:
    input:
        rules.mapping_other.output.fastq
    output:
        sam="reads/aligned/{sample}.mirbase_mature2.sam",
        fastq="reads/unaligned/{sample}.mirbase_mature2.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("mismatch_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "


rule mapping_genome:
    input:
        rules.mapping_miRBase_mature2.output.fastq
    output:
        sam="reads/aligned/{sample}.genome.sam",
        fastq="reads/unaligned/{sample}.genome.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("genome_params"),
        basename="ucsc_hg19"
    threads: pipeline_cpu_count()
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie "
        "{params.params} "
        "--threads {threads} "
        "{params.basename} "
        "{input} "
        "--un {output.fastq} "
        "-S {output.sam} "
