#!/usr/bin/perl
use strict;
use warnings;
# 检查参数
die "Usage: $0 test_transcripts_with_UTR_gene.fa output.txt\n" unless @ARGV == 2;

open my $IN,"$ARGV[0]";
open OUT,">$ARGV[1]";

print OUT "rna\tCDS\tGeneID\tgene\tproduct\tprotein_id\t5p_UTR\tCDS_seq\t3p_UTR\n";
my $current_header;
my $current_seq = '';

while(<$IN>){
chomp;
if($_=~/^>/){
	###判断是否存在 表头
	if (defined $current_header) {
		#print "$current_header\n";
		my ($rna,$CDS,$gene,$GeneID,$product,$protein_id);
		my @CDS_info;
	##获取转录本ID
        if($current_header=~/^>rna-([^\s]+).*?CDS=\d+-\d+/)    {
		$rna=$1;
		}else{
		print "can't find rna_id\n";
		$rna="NA";
		}

	###获取CDS信息
		if($current_header=~/CDS=([^\s]+).*?Dbxref/)    {
		$CDS=$1;
		}else{
		print "can't find CDS\n";
		$CDS="NA";
		}
	####
		if($current_header=~/gene=([^;]+)/)    {
		$gene=$1;
		}else{
		#print "can't find gene\n";
		$gene="NA";
		}

    ##获取GeneID    
		if($current_header=~/GeneID:(\d+)/)    {
		$GeneID=$1;
		}else{
		print "can't find GeneID\n";
		$GeneID="NA";
		}
	####获取编码蛋白名称 	
		if($current_header=~/product=([^;]+)/)    {
		$product=$1;
		}else{
		print "can't find product\n";
		$product="NA";
		}
	###	
		if($current_header=~/protein_id=([^;]+)/)    {
		$protein_id=$1;
		}else{
		print "can't find protein_id\n";
		$protein_id="NA";
		}
	####拆CDS信息
		@CDS_info=split(/\-/,$CDS);
		#print " $CDS_info[0]\t$CDS_info[1]\n";

		my $five_prime_utr = substr($current_seq, 0, $CDS_info[0] - 1);
		my $cds_seq = substr($current_seq, $CDS_info[0] - 1, $CDS_info[1] - $CDS_info[0] + 1);
		my $three_prime_utr = substr($current_seq, $CDS_info[1]);
		print OUT join("\t", $rna, $CDS, $GeneID, $gene, $product, $protein_id, $five_prime_utr, $cds_seq, $three_prime_utr), "\n";
		#print OUT join("\t", $rna, $CDS, $GeneID, $gene, $product, $protein_id), "\n";

		
		}

        $current_header = $_;
        $current_seq = '';
	}else {
        $current_seq .= $_;
    }

}