#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper; 
use File::Slurp;

print "I am $$\n";

{
my (@seq_map, @fq_tab) ; 
#$seq_map{read_file($ARGV[0])} = "1";
#@seq_map = read_file($ARGV[0]);
@fq_tab = read_file($ARGV[1]);
#warn Dumper \@seq_map; 
#chomp $map; 
#my @split = split /\t/, $map; 
#print $split[0]."\n";
#my $fq_tab = read_file($ARGV[1]);
#warn Dumper \%fq_tab;
#foreach my $seq (@seq_map ) { 
#print $fq_tab =~ /$seq/; 
# if ($fq_tab =~ /$seq/) { 
#	print $fq_tab."\n"; 
#	} 
#}
#$map =~ /TCAGAGAACTATCTTAAGGGCAAGAAATTGTCCTTTTT/;
#print "Found $count occurances\n";
}

#<STDIN>;
