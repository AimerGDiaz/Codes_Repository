#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp;


#my $forks = shift @ARGV;
#my $line_count = `wc -l  $ARGV[0] | awk '{print \$1}'`;
#my $parts = ( int($line_count/$forks) + 1) ;

my (%total, %count);
my @adapters = read_file($ARGV[1]);
chomp @adapters; 
#warn Dumper \@adapters;
#my %adapters = map { $adapters[$_] => "" } 0..$#adapters;
#@adapters = (""); 
#my $start = time ;
#for my $i (1 .. $forks) {
#my @coor =  split /_/,  $coordinates[$i -1];
#my $inf_limit = $coor[0]  ;
#my $sup_limit = $coor[1];
#print $inf_limit." vs  $sup_limit\n";

#open(FastqTab, "awk -v lim_inf=$inf_limit -v lim_sup=$sup_limit '{if (NR > lim_inf && NR < lim_sup ) print }' $ARGV[0] | ");
open(FastqTab, "$ARGV[0]");
my $header; 
my $out = $ARGV[0];
$out =~ s/\/?(.*)_fastqtab\.txt/$1/g;
open my $OUT, '>', $out."_cor_fastqtab.txt";
open my $OUT2, '>', $out."_cor.fq"; 
        while (<FastqTab>){
        my $fqtab = $_;
        chomp $fqtab;
        my @split = split /\t/, $fqtab;
		foreach my $adapter (@adapters) { 
		 	if ( $split[1] =~ m/\B$adapter$/g  ) { 	
			$split[0] = $split[0]."_S_final";
			#push @split, $header; 
			my $qual = $split[3];
		my $seq = $split[1];  
			$split[3] = substr $qual, 0, (length($qual) -  length($adapter)); 
			$split[1] =~ s/(.*)\B$adapter$/$1/g;
##http://www.regular-expressions.info/wordboundaries.html   \b and \B word boundaries 
##			$split[0] = $1; 
			#			} else ($split[0] =~ m/^$adapter\B/g ) { 
			# my $qual = $split[2];	
			#$split[2] = substr $qual, (length($qual) -  length($adapter)), length($qual); 
			#$split[0] =~ s/^$adapter\B(.*)/$1/g;
			} elsif ( length($adapter) >= 10 && $split[1] =~ s/(.*)\B$adapter.*/$1/mg ) { 
			$split[0] = $split[0]."_S_noise";	
			#			push @split, $header;
			my $qual = $split[3];
			my $seq = $1; 
			$split[3] = substr $qual, 0, length($seq); # (length($qual) -  length($adapter));
			}# else { 
				#			$split[0] = $split[0]."_noS";
			# push @split, $header;
			#	} 	
		} 	
##TCCTGTACTGAGCTGCCCCGAGTGGAATTCTCGGGTGCCAAGGAACTCCA	+SRR837449.1 HWI-ST937:130:D10R9ACXX:1:1101:1256:2148 length=50	CCCFFFFFHHHHHJJIJJJIJJFHHBFAFHIIIJJJIBDFHGFBH@GFGB
			if ( length($split[1]) >= 15 ) {
			print $OUT $split[0]."\t".$split[1]."\t+\t".$split[3]."\n";
		        print $OUT2 $split[0]."\n".$split[1]."\n+\n".$split[3]."\n";
	
			} 
#			#} else { 
		#	 print $OUT $split[0]."\t+\t".$split[2]."\n";
#			}  
#			 
#		
	} 
