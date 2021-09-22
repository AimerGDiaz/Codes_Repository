#!/usr/bin/perl

##Routine to generate a tabular file with the miRNA name and miR ID and the length of the seq

#To obtain additional information from the header use the shell code 
#for f in *v2[0-1].fa; do name=`echo $f | cut -d'.' -f 1`; tr ' ' '_' < $f > "$name"_c.fa ;done

#for f in hairpin_v2[0-1]_c.fa; do perl ../Code/lengh_seq.pl $f; done
use strict;
use warnings;

use Bio::SeqIO;

my $in  = Bio::SeqIO->new(-file => $ARGV[0],-format => 'Fasta'); # fasta file
my %seqs;
my $name = $ARGV[0]; 
$name =~ s/(.*)\.fa/$1/;

open my $OUT, '>', "length_"."$name".".txt";
while ( my $seq = $in->next_seq() ) {
	    $seqs{$seq->display_id} = $seq->seq; #hash of keys are header and
        #value are seq
    }
    

foreach my $key (keys %seqs){ #print for the key the value
my @split = split /\_/, $key;
my $miR_name = $split[0];
my $miR_ID = $split[1];
my $l = length ($seqs{$key});

my $out =  $miR_name."\t".$miR_ID."\t".$l."\n";

print $OUT $out; 

}     
    
