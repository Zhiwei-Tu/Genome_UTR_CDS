use strict;
use warnings;
use File::Basename;


# 打开一个输出文件用于保存合并的结果
open my $out_fh, '>>', 'merged_UTR_CDS_data.txt' or die "无法打开输出文件: $!";

open my $in_fh, '<', $ARGV[0] or die "无法打开文件 $ARGV[0]: $!";

# 获取文件夹名（即文件名）

my ($GCF_id,$taxid,$species);
$GCF_id =$ARGV[1];
$taxid =$ARGV[2];
$species=$ARGV[3];
# 逐行读取文件
while (my $line = <$in_fh>) {
	unless($line =~/CDS_seq/){
        chomp $line;
        # 跳过空行（如果有的话）
        next if $line =~ /^\s*$/ ;
            
        # 为每行添加文件名，并将其写入输出文件
        print $out_fh "$GCF_id\t$taxid\t$species\t$line\n";
        }

        # 关闭当前文件

    }


# 关闭输出文件
close $in_fh;
close $out_fh;

print "complete merge $ARGV[0]\n";
