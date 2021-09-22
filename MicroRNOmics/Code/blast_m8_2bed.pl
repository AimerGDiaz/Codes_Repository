#!/usr/bin/perl

##Routine to convert from m8 blast output  to  bed file
## for f in *.out.coincidence; do perl blast_m8_2bed.pl $f; done &
#
use strict;
use warnings;
use Data::Dumper;
use File::Basename;
##---------------------------------------To read length concatenate to a m8 output file  ----------------------------------

open(M8, "$ARGV[0]");
my $name = basename("$ARGV[0]");

$name =~ s/(.*)\.full\.out/$1/;
open my $OUT, '>', "$name.exact.bed";
open my $OUT2, '>', "$name.lookalike.bed";

	print "$name\n";

	while (<M8>){
        my $blast_out = $_ ; 
	chomp $blast_out;
#pre split
#blast output
#hsa-let-7a-1	chr9	100.00	80	0	0	1	80	96938239	96938318	2e-37	 159
#coincidence output
##miR_Name mirID Length query sbj identity alnLength mismatchCount gapOpenCount queryStart queryEnd subjectStart subjectEnd eVal bitScore
#age-mir-101	MI0002719	75	age-mir-101	chr1	100.00	75	0	0	1	75	65524191	65524117	2e-34	 149

##desired output
#chr start end name bitscore sense miRNA_id
	my @split = split /\t/, $blast_out;
#hsa-let-7a-1_MI0000060_Homo_sapiens_let-7a-1_stem-loop	chr9	100.00	80	0	0	1	80	96938239	96938318	2e-37	 159	100	hsa-let-7a-1	80	MI0000060
	my $chr = $split[1];
	my $al_score = $split[2];
	my $al_length = $split[3];
	my $mmatch = $split[4];
	my $gaps = $split[5]; 
	my $pstart = $split[8];
	my $pend = $split[9];
	my $score = $split[11];
	my $miRNA_name = $split[13];
	my $real_length = $split[14];
	my $miR_ID = $split[15];

	my ($sense, $out);
	my ($start, $end); 

	if ( $pend < $pstart ) { 
	$sense = "-";
	$end = $pstart; 
	$start = $pend; 
	} elsif ( $pstart < $pend ) { 
	$sense = "+"; 
 	$end = $pend;
	$start = $pstart;
	} 
	
	$out = $chr."\t".$start."\t".$end."\t".$miRNA_name."\t".$score."\t".$sense."\t".$miR_ID."\t".$real_length;
	my $cor_per = (($al_length * 100) / $real_length); 
	if ( $al_length eq $real_length && $al_score == "100" ) { 
	print $OUT $out."\n";
	 } elsif  ($cor_per > 90) { 
	print $OUT2 $out."\t".$al_length."\t".$al_score."\t".$mmatch."\t".$gaps."\n"; 
 	}  
#	my $chr_o = $chr;
#	$chr_o =~ s/chr(X)/23/;
#	$chr_o =~ s/chr(Y)/24/;
#	$chr_o =~ s/chr(\d+)/$1/;

#	my $chr_o = ($chr =~ /(chrY)/chr24/s);
#	$lines{$out} = [$chr_o,$start] ; 	
#	print $OUT  $out; 

}      ##end while

#foreach my $key ( sort { $lines{$a}[0] <=> $lines{$b}[0] || $lines{$a}[1] <=> $lines{$b}[1] } keys %lines ) {
#print $OUT $key ;
#} 

#%lines = ( );

#warn Dumper \%lines;
exit;
