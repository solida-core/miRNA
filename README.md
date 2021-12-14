# miRNA
miRNA analysis pipeline

This Snakemake-based workflow was designed with the aim of enable reproducible analysis of miRNA NGS data.

As the QIAseq miRNA Library Kit (QIAGEN) was used in our lab, the pipeline is configured for managing UMIs present in the read as suggested by the manufacturer. Anyway, few changes would allow data anlysis from different kits.

The pipeline can be considered as a hybrid solution between common state-of-the-art literature, as reported in [Potla et al.](https://doi.org/10.1016/j.ocarto.2020.100131) and Qiagen analysis guidelines.


## Requirements

To run miRNA pipeline, Conda must be present in your computer.    
To install Conda, see [https://conda.io/miniconda.html](https://conda.io/miniconda.html)

## Installation

You can directly clone the repository in your working directory
```bash
git clone https://github.com/solida-core/miRNA.git
```
Then you need to create the base environment.
```bash
cd miRNA
conda create -q -n MYENV_NAME python=3.7
conda env update -q -n MYENV_NAME --file environment.yaml
```
Once the virtual environment is ready, activate it and check the correct installation of Snakmake
```bash
conda activate MYENV_NAME
snakemake --version
```
## Run the Pipeline
To run the pipeline you need to edit manually the `config.yaml` file, providing paths for your references.
```bash
snakemake --configfile config.yaml --snakefile Snakefile --use-conda -d ANALYSIS_DIR
```



## Pipeline Description
The workflow consists of 6 main steps:
1. Get UMI: Qiagen UMIs are integrated in the read sequence, near the 3' adapter. To identify the 12 bases sequence of the UMI we use UMI_tools which allow to search the adapter sequence, discard it and keep the UMI sequence, includeing it in the header of the read. 
2. Trimming: TrimGalore is used for quality trimming and read length selection (default min read length is set to 16, max to 30). These values can be edited in the config.yaml file.
3. QC: a QC report is generated with MultiQC, including information from FastQC, TrimGalore and Mirtrace.
4. Mapping: reads are aligned against multiple databases. Only reads that do not map to a db undergo alignment against the succesive database. 
5. Deduplication and Count: UMIs are used for the deduplication of mapped reads and then a table with counts for each miRNA is generated.
6. Discovery: WORK IN PROGRESS