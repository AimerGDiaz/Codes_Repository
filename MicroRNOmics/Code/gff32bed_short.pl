#!/usr/bin/perl

##Routine to convert from miRNA gff3 derived from mirBase human genome GRCh37.p5 (hg19) to mature bed  and hairpin bed
#perl  length.blast_filter.txt
use strict;
use warnings;
use Data::Dumper;

##---------------------------------------To read GFF3 file from mirBase ----------------------------------

open(GFF, "$ARGV[0]");
my $name = $ARGV[0];
$name =~ s/\.gff3//;
open my $BED, '>', "$name".".bed";
	print "$name\n";

	while (<GFF>){
#	if( $. >= 14 ) { 
        my $gff3 = $_ ; 
	chomp $gff3;
#pre split hairpin
#chr19	.	miRNA_primary_transcript	20510081	20510163	.	-.	ID=MI0006407;Alias=MI0006407;Name=hsa-mir-1270-1

#pre split mature 
#chrX    .       miRNA   49767773        49767794        .       +       .       ID=MIMAT0002888;Alias=MIMAT0002888;Name=hsa-miR-532-5p;Derives_from=MI0003205



##post split
##'chrX',  '.', 'miRNA',  '112023956', '112023974', '.', '-',  '.', 'ID=MIMAT0016923;Alias=MIMAT0016923;Name=hsa-miR-4329';

	my @split = split /\t/, $gff3;
	my $chr = $split[0];
	my $start = $split[3];
	my $end = $split[4];
	my $strand = $split[6];
	my $add_info = $split[8];
	my @add_info = split /;/, $add_info;
		for (my $i=0; $i <= $#add_info; $i++) { 
		$add_info[$i] =~ s/.*=(.*)/$1/;
		} #close for
	warn Dumper \@add_info; 
	my $ID = $add_info[0];
	my $Name = $add_info[2];
#chr1	17369	17436	Cluster_6	 135	-	PRLG12	68
##chr9    96938295        96938315        hsa-let-7a-3p   42.1    +       MIMAT0004481    21
#
        print $BED $chr."\t".$start."\t".$end."\t".$Name."\t"."0(F_gff3)"."\t".$strand."\t".$ID."\t".(($end+1)-$start)."\n";
     } ##end while

exit;
