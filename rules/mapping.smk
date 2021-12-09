

rule mapping_miRBase_mature:
    input:
        "reads/trimmed/{sample}-trimmed.fq",
    output:
        sam="reads/aligned/{sample}.mirbase_mature.sam",
        fastq="reads/unaligned/{sample}.mirbase_mature.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params" if config.get("allow_multimapping")=="NO" else "strict_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("mirna_mature"))
    log:
        "logs/bowtie/{sample}_mapping_mature.txt"
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
        ">& {log}"


rule mapping_miRBase_hairpin:
    input:
        rules.mapping_miRBase_mature.output.fastq
    output:
        sam="reads/aligned/{sample}.mirbase_hairpin.sam",
        fastq="reads/unaligned/{sample}.mirbase_hairpin.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params" if config.get("allow_multimapping") == "NO" else "strict_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("mirna_hairpin"))
    log:
        "logs/bowtie/{sample}_mapping_hairpin.txt"
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
        ">& {log}"


rule mapping_piRNA:
    input:
        rules.mapping_miRBase_hairpin.output.fastq
    output:
        sam="reads/aligned/{sample}.piRNA.sam",
        fastq="reads/unaligned/{sample}.piRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params" if config.get("allow_multimapping") == "NO" else "strict_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("pirna"))
    log:
        "logs/bowtie/{sample}_mapping_pirna.txt"
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
        ">& {log} "


rule mapping_tRNA:
    input:
        rules.mapping_piRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.tRNA.sam",
        fastq="reads/unaligned/{sample}.tRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params" if config.get("allow_multimapping") == "NO" else "strict_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("trna"))
    log:
        "logs/bowtie/{sample}_mapping_trna.txt"
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
        ">& {log}"


rule mapping_rRNA:
    input:
        rules.mapping_tRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.rRNA.sam",
        fastq="reads/unaligned/{sample}.rRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params" if config.get("allow_multimapping") == "NO" else "strict_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("rrna"))
    log:
        "logs/bowtie/{sample}_mapping_rrna.txt"
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
        ">& {log} "


rule mapping_mRNA:
    input:
        rules.mapping_rRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.mRNA.sam",
        fastq="reads/unaligned/{sample}.mRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params" if config.get("allow_multimapping") == "NO" else "strict_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("mrna"))
    log:
        "logs/bowtie/{sample}_mapping_mrna.txt"
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
        ">& {log} "


rule mapping_other:
    input:
        rules.mapping_mRNA.output.fastq
    output:
        sam="reads/aligned/{sample}.other_miRNA.sam",
        fastq="reads/unaligned/{sample}.other_miRNA.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("strict_params" if config.get("allow_multimapping") == "NO" else "strict_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("other_mirna"))
    log:
        "logs/bowtie/{sample}_mapping_other.txt"
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
        ">& {log} "


rule mapping_miRBase_mature2:
    input:
        rules.mapping_other.output.fastq
    output:
        sam="reads/aligned/{sample}.mirbase_mature2.sam",
        fastq="reads/unaligned/{sample}.mirbase_mature2.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("mismatch_params" if config.get("allow_multimapping") == "NO" else "mismatch_multimap_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("mirna_mature"))
    log:
        "logs/bowtie/{sample}_mapping_mature2.txt"
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
        ">& {log} "


rule mapping_genome:
    input:
        rules.mapping_miRBase_mature2.output.fastq
    output:
        sam="reads/aligned/{sample}.genome.sam",
        fastq="reads/unaligned/{sample}.genome.fastq"
    params:
        params=config.get("rules").get("bowtie_mapping").get("genome_params"),
        basename=resolve_single_filepath(*references_abs_path(), config.get("genome"))
    log:
        "logs/bowtie/{sample}_mapping_genome.txt"
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
        ">& {log} "