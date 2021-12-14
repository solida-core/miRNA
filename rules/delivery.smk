def get_sample_by_client(wildcards, reheader, label='LIMS', structure="folder/{sample}.extension"):
    re.sub(r"{sample}",reheader.loc[wildcards.Client,[label]][0], structure)
    return re.sub(r"{sample}",reheader.loc[wildcards.Client,[label]][0], structure)


rule delivery_counts:
    input:
        lambda wildcards: get_sample_by_client(wildcards, reheader, label=config.get("internal_sid"), structure="reads/counts/{sample}.mirna.txt")
    output:
        report("delivery/counts/{Client}_mirna_counts.tsv", caption="../report/counts.rst", category="miRNA")
    shell:
        "cp {input} {output}"
