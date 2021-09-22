#!/usr/bin/perl

##Routine to convert from miRNA gff3 derived from mirBase human genome GRCh37.p5 (hg19) to mature bed  and hairpin bed

use strict;
use warnings;
use Data::Dumper;

##---------------------------------------To read GFF3 file from mirBase ----------------------------------
open(GFF, "$ARGV[0]");
my $name = $ARGV[0];
$name =~ s/\.gff3//;
open my $Hairpin_premiRNA, '>', "$name"."_pre_miRNA.bed";
open my $Mature_miRNA, '>', "$name"."_mature_miRNA.bed";
open my $Total_miRNA, '>', "$name"."_total.bed";
	
	print "$name\n";

	while (<GFF>){
	if( $. >= 14 ) { 
	my ($hairpin,$pre_out,  $m_out,  $out);
        my $gff3 = $_ ; 
	chomp $gff3;
#pre split
##chr1    .       miRNA   17409   17431   .       -       .       ID=MIMAT0027618;Alias=MIMAT0027618;Name=hsa-miR-6859-5p;Derives_from=MI0022705
##post split
##'chrX',  '.', 'miRNA',  '112023956', '112023974', '.', '-',  '.', 'ID=MIMAT0016923;Alias=MIMAT0016923;Name=hsa-miR-4329;Derives_from=MI0015901'
#
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
	my $ID = $add_info[0];
	my $Name = $add_info[2];
		
		if (defined $add_info[3] ) { 
		#chr8_hsa-mir-5681b_MI0019293	75460785	75460844	hsa-mir-5681b	-	0
		#chr8_hsa-miR-5681b_MIMAT0022480	75460819	75460840	hsa-miR-5681b	-	MI0019293
		$hairpin = $add_info[3];
                $m_out = $chr."\t".$start."\t".$end."\t".$Name."_".$ID."\t".$strand."\t".$hairpin."\n";
                $out = $chr."\t".$start."\t".$end."\t".$Name."_".$ID."\t".$strand."\t".$hairpin."\n";
                print $Mature_miRNA $m_out;
                print $Total_miRNA $out;

		} else {
		$pre_out = $chr."\t".$start."\t".$end."\t".$Name."_".$ID."\t".$strand."\t"."0"."\n";
                $out = $chr."\t".$start."\t".$end."\t".$Name."_".$ID."\t".$strand."\t"."0"."\n";
                print $Hairpin_premiRNA $pre_out;
                print $Total_miRNA $out;

		}

		      } #close if 
     } ##end while


exit;
