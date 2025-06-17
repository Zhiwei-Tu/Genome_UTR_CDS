

## Description
This section of the code uses Perl language to batch download NCBI genomic data in various file formats, including fna, gtf, gff, and others.

## Preparation
Ensure that the system has Perl and gffread software installed.

### Perl Download
  [https://www.perl.org/get.html](https://www.perl.org/get.html)
### gffread Download
  [https://github.com/gpertea/gffread](https://github.com/gpertea/gffread)

### Step 1: Download Genomic Data List from NCBI

Example: Download the `assembly_summary.txt` file for `vertebrate_mammalian` to use for subsequent genomic data downloads. If data for other species is required, download and merge the files as needed.
[Download `assembly_summary.txt`](https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/assembly_summary.txt)

### Columns in `assembly_summary.txt`

assembly\_accession, bioproject, biosample, wgs\_master, refseq\_category, taxid, species\_taxid, organism\_name, infraspecific\_name, isolate, version\_status, assembly\_level, release\_type, genome\_rep, seq\_rel\_date, asm\_name, asm\_submitter, gbrs\_paired\_asm, paired\_asm\_comp, ftp\_path, excluded\_from\_refseq, relation\_to\_type\_material, asm\_not\_live\_date, assembly\_type, group, genome\_size, genome\_size\_ungapped, gc\_percent, replicon\_count, scaffold\_count, contig\_count, annotation\_provider, annotation\_name, annotation\_date, total\_gene\_count, protein\_coding\_gene\_count, non\_coding\_gene\_count, pubmed\_id

### Step 2: Batch Download
Run the following code:
`perl multi_run.pl test_assembly_summary.txt`

### Step 3: Filter Protein-Coding Transcript IDs Based on GFF File and Retrieve Corresponding Transcripts with UTR and CDS Sequences
Run the following code:
`perl multi_UTR_CDS.pl test_assembly_summary.txt`

### Step 4: Merge All Species Files
Run the following code:
`perl multi_merge_UTR_CDS.pl test_assembly_summary.txt`


