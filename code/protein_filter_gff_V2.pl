#!/usr/bin/perl
use strict;
use warnings;
# 检查参数
die "Usage: $0 protein_info.txt input.gff output.gff\n" unless @ARGV == 3;

open my $IN1,"$ARGV[0]";
my $IN2;
if($ARGV[1] =~/.gz$/i){
	open $IN2, "zcat $ARGV[1] |";
}else{
	open $IN2, "$ARGV[1]";
}

open OUT,">$ARGV[2]";


my %hash1;
while(<$IN1>){
    chomp;
    my @arry1 = split(/\t/, $_);
    $hash1{$arry1[0]} = 1;  # 只存储键的存在与否
}

close $IN1;

while( <$IN2>){
	chomp $_;
	my $rna;
	if($_ =~ /Parent=rna-([^;]+)/){
		$rna=$1;	
		if(exists $hash1{$rna}){
			print OUT "$_\n";
		}

	}

}

close $IN2;
close OUT;