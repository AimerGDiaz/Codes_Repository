#!/usr/bin/perl

###Routine to order numerically the bed information given by intersectBed 
# perl order_bed.pl  DWOS13-12.miRNA.bed 

use strict;
use warnings;
use Data::Dumper;

open(BED, "$ARGV[0]");

	my $name = $ARGV[0];
        $name =~ s/(.*)\.bed/$1/;
        #print "$name \n"; 
        open my $OUT, '>>', "$name".".order.bed";
my $line = 0; 
my %Bed1;    
	while (<BED>){
	my $bed = $_;
        chomp $bed;
        $line ++;
        my @split = split /\t/, $bed;
     	$Bed1{$line}=[ @split ];     
#warn Dumper \%Bed1;

		     } 


foreach my $key (sort hashValueAscendingNum (keys(%Bed1))) {
 my $join = join ("\t", @{ $Bed1{$key} }) ;  	 
	print $OUT $join;
}

sub hashValueAscendingNum {
  $Bed1{$a}[0] cmp  $Bed1{$b}[0] || $Bed1{$a}[1] <=> $Bed1{$b}[1] 
}
