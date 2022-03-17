#!/usr/bin/perl
#
# last changed Time-stamp: <2007-07-22 15:24:18 alex>
#
#Hi Clara,
#
#sure. Your can find the mapper.pl in my home directory:
#
#~alex/bin/perls/mapper.pl
#
#The usage is:
#./mapper.pl [fileIn] [abbreviation]
#
#The resulting file with the changed header is printed on STDOUT. So you have
#to
#pipe it in a file. A fileIn.map is created which contains the old and the new
#headers for remapping. The new headers are a combination of the abbreviation
#and
#continuous numbers.
#For the abbreviation you could choose the first two letters of the organism.
#So
#in case of Homo sapiens, for example, you could write:
#
#./mapper.pl Homosapiens.fa HS > Homosapiens.new.fa
#
#This would write the sequences with the changed headers in Homosapiens.new.fa
#and create a Homosapiens.fa.map with the old and new headers.
#
#So if the original file (Homosapiens.fa) looked like this:
#
#>123456
#ACGU
#>9876
#AGUG
#
#the new file (Homosapiens.new.fa) would look like this:
#
#>HS1
#ACGU
#>HS2
#AGUG
#
#and you would get a mapping file (Homosapiens.fa.map) which looks like this:
#
#HS1     123456
#HS2     9876
#
#
#Alright? If you have any questions, don't hesitate to ask..
#
#alex
#
#############################################################
use warnings;
use strict;
use Bio::SeqIO;

my %NR;
my %NRori;
my $in = shift || die "Usage: ./mapper.pl [fileIn] [abbreviation]\nmissing fileIn...exiting\n";
my $short = shift || die "Usage: ./mapper.pl [fileIn] [abbreviation]\nmissing abbreviation...exiting\n";
my $file = Bio::SeqIO->new(-file => $in, -format => "fasta");
my $num = 1;

while (my $fasta = $file->next_seq) {
    my $def = $num;
    $NR{$def} = $fasta->seq;
    $NRori{$num} = $fasta->id ." " .$fasta->desc;;
    $num++;
}
foreach my $defs(keys %NR) {
    print ">".$short.$defs."\n".$NR{$defs}."\n";
}

open(OUT, ">$in.map");
foreach my $defs(keys %NRori) {
    print OUT $short.$defs."\t".$NRori{$defs}."\n";
}
close(OUT);
