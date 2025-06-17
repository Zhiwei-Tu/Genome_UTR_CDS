#!/usr/bin/perl
use strict;
use warnings;
# 检查参数
die "Usage: $0 input.gff output.txt\n" unless @ARGV == 2;
my $IN;
if($ARGV[0] =~/.gz$/i){
	open $IN, "zcat $ARGV[0] |";
}else{
	open $IN, "$ARGV[0]";
}
open OUT, ">$ARGV[1]";
# 打印列标题
print OUT "rna\tgene\tGeneID\tproduct\tprotein_id\n";
# 定义一个哈希，存储每个rna的信息
# 用于存储每个 RNA 的最佳记录
my %best;

while (my $line = <$IN>) {
    chomp $line;
    
    # 仅处理包含 protein_id=NP_ 的行
    next unless $line =~ /protein_id=[NX]P_/;

    # 提取字段
    # 1. RNA：Parent=rna-XXX; 这里 XXX 最多到下一个分号为止
    my ($rna) = $line =~ /Parent=rna-([^;]+)/;
    $rna ||= 'NA';

    # 2. gene
    my ($gene) = $line =~ /gene=([^;]+)/;
    $gene ||= 'NA';

    # 3. GeneID
    my ($gene_id) = $line =~ /GeneID:(\d+)/;
    $gene_id ||= 'NA';

    # 4. product
    my ($product) = $line =~ /product=([^;]+)/;
    $product ||= 'NA';

    # 5. protein_id
    my ($prot) = $line =~ /protein_id=([^;]+)/;
    $prot ||= 'NA';

    # 计算“完整度”：非 NA 字段的数量
    my $score = 0;
    $score++ for grep { $_ ne 'NA' } ($rna, $gene, $gene_id, $product, $prot);

    # 如果这是该 RNA 第一次出现，或当前记录更“完整”，则更新
    if (!exists $best{$rna} or $score > $best{$rna}{score}) {
        $best{$rna} = {
            gene      => $gene,
            gene_id   => $gene_id,
            product   => $product,
            prot_id   => $prot,
            score     => $score,
        };
    }
}

# 输出每个 RNA 的最优条目
for my $rna (sort keys %best) {
    my $rec = $best{$rna};
        if($rna=~/^[NX]M_\d+\.\d+$/){
    print OUT join("\t",
        $rna,
        $rec->{gene},
        $rec->{gene_id},
        $rec->{product},
        $rec->{prot_id},
    ), "\n";
}
}
close $IN;
close OUT;
