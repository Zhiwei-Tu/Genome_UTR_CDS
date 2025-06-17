#! /usr/bin/perl

###list 是一列多行的数据，一般代表样本编号
use warnings;
use strict;
die "Usage: $0  input.txt\n" unless @ARGV == 1;
use threads;
use threads::shared;
use POSIX qw(strftime);
my @threads;

open IN,$ARGV[0];
my @list = <IN>;

my $maxthread = 3; #allowed max threads
my $thread_num = 0;

#my @list = (1,2,3,4,5,6,7,8,9,10);

for (my $i = 0;$i<@list;$i++)
{
	my $program = $list[$i];
	$program =~ s/\s+//;
	if ( $thread_num <= $maxthread )
	{	
		my $thread = threads->create(\&doProgram,$program);
		$thread_num ++;
	}
	else
	{
		while( $thread_num > $maxthread )
		{
			sleep 5;
			foreach my $t(threads->list(threads::joinable))
			{
				$t->join();
				$thread_num --;
			}
		}
		$i --;
	}
}

while( $thread_num != 0)
{
	sleep 5;
	foreach my $t(threads->list(threads::joinable))
        {
             $t->join();
             $thread_num --;
        }
}

sub doProgram()
{
	my $start_time = time;
	my $formatted_start_time = strftime("%Y-%m-%d %H:%M:%S", localtime($start_time));
	my $cmd = shift;
	my @arry=split("\t",$cmd);
	my @V=split("/",$arry[18]);
	my $file_pre=$V[$#V];
	print "$V[$#V]\n\n";
	#print "$arry[0]\t$arry[6]\t$arry[18]\t$arry[23]\n";
	my $fna_gz="./".$arry[23]."/".$file_pre."/".$file_pre."_genomic.fna.gz";
	my $fna="./".$arry[23]."/".$file_pre."/".$file_pre."_genomic.fna";
	my $gtf_gz="./".$arry[23]."/".$file_pre."/".$file_pre."_genomic.gtf.gz";
	my $gff_gz="./".$arry[23]."/".$file_pre."/".$file_pre."_genomic.gff.gz";
	
	$arry[6] =~ s/ /_/g;
	$arry[23] =~ s/ /_/g;
	my $out_dir="/home/tuzhiwei/Download/wj/UTR_CDS/".$arry[23]."/".$file_pre;
	#print "running $cmd\n";
	`mkdir -p $out_dir`;
	my $protein_info=$out_dir."/".$file_pre."_protein_info.txt";
	my $protein_filter=$out_dir."/".$file_pre."_protein_filter.gff";
	my $transcripts=$out_dir."/".$file_pre."_transcripts_with_UTR_gene.fa";
	my $UTR_CDS=$out_dir."/".$file_pre."_UTR_CDS.txt";	
	`perl ./get_protein_info_V2.pl $gff_gz $protein_info`;
	#print "gffread $protein_filter -g $fna -w $transcripts -G --keep-genes\n";
	`perl ./protein_filter_gff_V2.pl $protein_info $gff_gz $protein_filter`;
	`[ -e $fna ] || gunzip $fna_gz`;
	`gffread $protein_filter -g $fna -w $transcripts -G --keep-genes`;
	`perl ./split_UTR_CDS.pl $transcripts $UTR_CDS`;

	#print "sh $sh_code\n";
	my $end_time = time;
	my $formatted_end_time = strftime("%Y-%m-%d %H:%M:%S", localtime($end_time));
	my $runing_time = ($end_time - $start_time)/60;
	#print "startime:$formatted_start_time  \n endtime:$formatted_end_time  \n $cmd runing time is $runing_time min\n";

}
print "finish running code\n";
