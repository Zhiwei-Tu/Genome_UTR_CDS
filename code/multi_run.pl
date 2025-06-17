#! /usr/bin/perl

use warnings;
use strict;
use threads;
use threads::shared;
die "Usage: $0 input.txt\n" unless @ARGV == 1;
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
	print "$arry[0]\t$arry[6]\t$arry[18]\t$arry[23]\n";
	my $fna_download_link=$arry[18]."/".$file_pre."_genomic.fna.gz";
	my $gtf_download_link=$arry[18]."/".$file_pre."_genomic.gtf.gz";
	my $gff_download_link=$arry[18]."/".$file_pre."_genomic.gff.gz";
	my $check_download_link=$arry[18]."/"."md5checksums.txt";
	$arry[6] =~ s/ /_/g;
	$arry[23] =~ s/ /_/g;
	my $out_dir="./".$arry[23]."/".$file_pre;
	#print "running $cmd\n";
	`mkdir -p $out_dir`;
	`wget -P $out_dir -c $fna_download_link`;
	`wget -P $out_dir -c $gtf_download_link`;
	`wget -P $out_dir -c $gff_download_link`;
	`wget -P $out_dir -c $check_download_link`;
	#print "sh $sh_code\n";
	my $end_time = time;
	my $formatted_end_time = strftime("%Y-%m-%d %H:%M:%S", localtime($end_time));
	my $runing_time = ($end_time - $start_time)/60;
	#print "startime:$formatted_start_time  \n endtime:$formatted_end_time  \n $cmd runing time is $runing_time min\n";

}
print "finish running code\n";
