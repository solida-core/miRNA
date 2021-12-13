# miRNA
miRNA analysis pipeline

This Snakemake-based workflow was designed with the aim of enable reproducible analysis of miRNA NGS data.

As the QIAseq miRNA Library Kit (QIAGEN) was used in our lab, the pipeline is configuread for managing UMIs present in the read as suggested by the manufacturer. Anyway, few changes would allow data anlysis from different kits.

The pipeline can be considered as a hybrid solution between common state-of-the-art literature and Qiagen analysis guidelines.


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

##
Steps:
- get UMI
- trim
- QC
- aln vs miRBase
- aln vs genome
- combine
- discovery