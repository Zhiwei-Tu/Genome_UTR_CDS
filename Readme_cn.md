描述
这部分代码使用perl语言，批量下载NCBI基因组数据包含fna,gtf,gff等多种格式文件。

准备
需要系统已安装perl和gffread软件
perl 下载
https://www.perl.org/get.html
gffread下载
https://github.com/gpertea/gffread

Step1:从NCBI下载基因组数据list

例:下载vertebrate_mammalian 的assembly_summary.txt文件，用于后续的下载基因组数据。有需要其他物种，可以下载后合并处理
https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/assembly_summary.txt

###下载assembly_summary.txt 列名
assembly_accession	bioproject	biosample	wgs_master	refseq_category	taxid	species_taxid	organism_name	infraspecific_name	isolate	version_status	assembly_level	release_type	genome_rep	seq_rel_date	asm_name	asm_submitter	gbrs_paired_asm	paired_asm_comp	ftp_path	excluded_from_refseq	relation_to_type_material	asm_not_live_date	assembly_type	group	genome_size	genome_size_ungapped	gc_percent	replicon_count	scaffold_count	contig_count	annotation_provider	annotation_name	annotation_date	total_gene_count	protein_coding_gene_count	non_coding_gene_count	pubmed_id

step2：批量下载
运行代码：
perl multi_run.pl test_assembly_summary.txt

step3:根据gff文件筛选编码蛋白质转录本ID,获取对应的转录本并获取UTR和CDS序列
perl multi_merge_UTR_CDS.pl test_assembly_summary.txt
