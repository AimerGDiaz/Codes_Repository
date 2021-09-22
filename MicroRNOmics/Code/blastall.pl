#!/usr/bin/perl 

use warnings;
use strict;
use Parallel::ForkManager;

my @genomes =('/scr/hercules1san/genomes/Homo_sapiens/hg19/hg19'); # , '/scr/hercules1san/genomes/Homo_sapiens/hg38/hg38') ;
  
my $query = $ARGV[0];
my @outs;



foreach my $genome (@genomes)
	{
	
     my $tmp_out = $genome;
     $tmp_out =~ s/(.*)\/(.*)/$2/g;
     my $tmp_out1 = $query;
     $tmp_out1 =~ s/(.*)_c\.fa/$1/g;
     my $out = $tmp_out."_".$tmp_out1.".out";
#	print $out."\n";
	  
    	 system("blastall -p blastn -d $genome -i $query -F F -e 1e-5 -o $out -m 8");
	
} 



































































