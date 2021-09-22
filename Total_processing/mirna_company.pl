#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp;

my (%total, %count);
my @adapters = read_file($ARGV[1]);
chomp @adapters; 
my $out = $ARGV[0];
$out =~  s/(.*)_raw.fq.gz/$1/g;

open my $OUT, '>', "miRNA_3prime_company_".$out.".txt";
open my $OUT2, '>', "miRNA_3prime_company_".$out.".fa";
my %seq2; 
#open(FastqTab, "zcat $ARGV[0] | grep -f $ARGV[1]  | " );
#my $count = 0; 
		foreach my $adapter (@adapters) {
open(FastqTab, "zcat $ARGV[0] | grep  $adapter  | " );
		while (<FastqTab>){

		my $fqtab = $_;
		chomp $fqtab;
		my $seq = $fqtab;
			 $seq =~ s/.*$adapter\B(.*)/$1/mg ;  
#	 if ( $seq =~ s/.*$adapter\B(.*)/$1/mg ) {
#		 if ( $seq  ne  $fqtab ) { 	 
			my $seq2= substr $seq, 0, 23; # (length($qual) -  length($adapter));

#I f the number is small low it will recognize several mappign sites in hg19 and will remove real noise seqs 
#if the numer is too high it wont recognize nonmiR seq with noise 
#
#An optimization problem
		$seq2{$seq2} = "1"; 
#print "$fqtab \t $seq  \t $seq2 \t $adapter \n"; 
#} else {
#next; 
 			
#$count ++; 
#			} 
}	
}
my $count = 0; 
foreach my $key (keys %seq2) {
if (  length($key) >= 15 ) {
print $OUT $key."\n";
$count ++; 
print $OUT2 ">3Noise_".$count."\n".$key."\n";  
}##print $key."\n";
}
#print "count $count\n";
