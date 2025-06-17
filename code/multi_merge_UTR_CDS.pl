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

my $maxthread = 0; #allowed max threads
my $thread_num = 0;

#my @list = (1,2,3,4,5,6,7,8,9,10);
open OUT,">merged_UTR_CDS_data.txt";
#print OUT "assembly_accession\ttaxid\tspecies\trna\tCDS\tGeneID\tgene\tproduct\tprotein_id\t5p_UTR\tCDS_seq\t3p_UTR\n";
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
	my ($GCF_id,$taxid,$species);
	if( $file_pre=~ /^(GCF_\d+\.\d+)_/){
	$GCF_id=$1;
	}else{
		print "can't find GCF_id\n";
	}
	
	$arry[4] =~ s/ /_/g;
	$taxid=$arry[4];
	$arry[6] =~ s/ /_/g;
	$species=$arry[6];
	$arry[23] =~ s/ /_/g;
	my $input_dir="/home/tuzhiwei/Download/wj/UTR_CDS/".$arry[23]."/".$file_pre;
	#print "running $GCF_id\n";
	#print " $input_dir\n";
	my $input_file=$input_dir."/".$file_pre."_UTR_CDS.txt";

	`perl merge_UTR_CDS.pl $input_file $GCF_id $taxid $species`;
	#print "perl merge_UTR_CDS.pl $input_file\t$GCF_id\t$taxid\t$species\n";

	#print "sh $sh_code\n";
	my $end_time = time;
	my $formatted_end_time = strftime("%Y-%m-%d %H:%M:%S", localtime($end_time));
	my $runing_time = ($end_time - $start_time)/60;
	#print "startime:$formatted_start_time  \n endtime:$formatted_end_time  \n $cmd runing time is $runing_time min\n";

}
print "finish running code\n";
