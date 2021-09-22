#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

open(Aln, "$ARGV[0]"); 
        my $name = $ARGV[0];
        $name =~ s/\.aln//;
my %aln; 
 while (<Aln>){
    my $aln = $_;
    chomp $aln;
#	$aln =~ s/(^hsa.*)\s+([ACGU-].*)/$1$2/ ;
	$aln =~ s/(^hsa.*)\s+([ACGT-].*)/$1$2/ ;	
    	my $feature = $1;
        my $seq = $2;
	$feature =~ s/\s+//;
	
	push @{$aln{$feature}}, $seq;

               } ##end while1
#warn Dumper \%aln;
	foreach my $key (keys %aln){
	my $seq= join "", @{$aln{$key}};
	print $key."\t".$seq."\n"; 
	} 
