#!/usr/bin/perl
use strict;
use warnings;

use Bio::SeqIO;

my $in = Bio::SeqIO->new( -file => $ARGV[0] ); # locations of the
                                                #original fasta file
my $filter_keyword = $ARGV[1]; #key of the header
my $out = Bio::SeqIO->new( -file => ">$ARGV[2].fa", -format =>
    'Fasta'); # save key.fasta
while (my $seq = $in->next_seq) {
#    print $seq->id . "\n";
    if ($filter_keyword eq 'all' || $seq->id =~ /(.*)$filter_keyword/i) {
        $out->write_seq($seq);
    }
}

