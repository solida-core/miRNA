## TODO
## gli allineamenti contro mirtbase mature 1 e 2 vanno sortati e mergiati
## convertiti in bam
## sortati e indexati
## deduplicati
## indexati
## conta
rule samtools_sam_to_bam:
    input:
        first="reads/aligned/{sample}.mirbase_mature.sam",
        second="reads/aligned/{sample}.mirbase_mature2.sam"
    output:
        first="reads/aligned/{sample}.mirbase_mature.bam",
        second="reads/aligned/{sample}.mirbase_mature2.bam"
    conda:
        "../envs/samtools.yaml"
    benchmark:
        "benchmarks/samtools/sam_to_bam/{sample}.txt"
    params:
        genome=resolve_single_filepath(*references_abs_path(),
                                       config.get("genome_fasta")),
        output_fmt="BAM"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=99)
    shell:
        "samtools view -b "
        "--threads {threads} "
        "-T {params.genome} "
        "-o {output.first} "
        "-O {params.output_fmt} "
        "{input.first} && "
        "samtools view -b "
        "--threads {threads} "
        "-T {params.genome} "
        "-o {output.second} "
        "-O {params.output_fmt} "
        "{input.second} "


rule samtools_sort:
   input:
       first="reads/aligned/{sample}.mirbase_mature.bam",
       second="reads/aligned/{sample}.mirbase_mature2.bam"
   output:
       first="reads/aligned/{sample}.mirbase_mature.sorted.bam",
       second="reads/aligned/{sample}.mirbase_mature2.sorted.bam"
   conda:
       "../envs/samtools.yaml"
   params:
       tmp_dir=tmp_path(path=config.get("tmp_dir")),
       genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta")),
       output_fmt="CRAM"
   benchmark:
       "benchmarks/samtools/sort/{sample}.txt"
   threads: conservative_cpu_count(reserve_cores=2, max_cores=99)
   shell:
       "samtools sort "
       "--threads {threads} "
       "-T {params.tmp_dir} "
       "-O {params.output_fmt} "
       "--reference {params.genome} "
       "-o {output.first} "
       "{input.first} && "
       "samtools sort "
       "--threads {threads} "
       "-T {params.tmp_dir} "
       "-O {params.output_fmt} "
       "--reference {params.genome} "
       "-o {output.second} "
       "{input.second} "


rule samtools_merge:

    input:
        first = "reads/aligned/{sample}.mirbase_mature.sorted.bam",
        second = "reads/aligned/{sample}.mirbase_mature2.sorted.bam"
    output:
        "reads/aligned/{sample}.mirna.bam"
    conda:
        "../envs/samtools.yaml"
    benchmark:
        "benchmarks/samtools/merge/{sample}.txt"
    params:
        cmd='samtools',
        genome=resolve_single_filepath(*references_abs_path(), config.get("genome_fasta")),
        output_fmt="BAM"
    threads: conservative_cpu_count(reserve_cores=2, max_cores=99)
    shell:
        "samtools merge "
        "--threads {threads} "
        "-O {params.output_fmt} "
        "--reference {params.genome} "
        "{output} "
        "{input.first} {input.second} "


rule index:
    input:
        rules.samtools_merge.output
    output:
        "reads/aligned/{sample}.mirna.bam.bai"
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools index "
        "{input}"


rule index_deduplicated:
    input:
        "reads/dedup/{sample}.mirna_dedup.bam"
    output:
        "reads/dedup/{sample}.mirna_dedup.bam.bai"
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools index "
        "{input}"

