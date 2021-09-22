#!/usr/bin/perl

#Routine to recover one specific sequence without flanking regions.
#perl hsa_mir_extraction.pl /scratchsan/genomes/Homo_sapiens/hg19/hg19.fa hg19_hairpin_v21.final.o.bed
use strict;
use warnings;
use Bio::SeqIO;
use Data::Dumper;
#Bio::FeatureIO::bed;
#----------------------------------------To create hash to store genome as : key = header and value= sequence

my $genome = $ARGV[0];

      	my $in  = Bio::SeqIO->new(-file => "$genome" ,
                           -format => 'Fasta');
        my %seqs;
        while ( my $seq = $in->next_seq() ) 

		{
                    $seqs{$seq->display_id} = $seq->seq;
		}

#print Dumper(\%seqs);
#----------------------------------------------------------------------------------------------------------------


 
#---------------------------------------To read BED file from tRNAscan output ----------------------------------
open(BED, "$ARGV[1]");

    while (<BED>){
    chomp;
    my @split = split /\t/, $_;
#chr7    30329410        30329506        Cluster_10       192    +       PRLG3   97
#chr1	17369	17436	hsa-mir-6859-r	 135	-	MI-Redundancy	68	
#chr18	55345858	55345888	12d;12m;24d;	143	+	sl=55345853:55345893;dl=55345854:55345894;sc=35;ec=104;soc=155;tc=65;rm=55345873;bm=55345876;sd=10.9
#0	30
#
	my $chr = $split[0];
	my $start = $split[1];
    	my $end = $split[2];
        my $mir = $split[3];
	my $score = $split[4];
  	my $sense = $split[5];
#	print $sense." before \n";
#if ($sense ne "+" | $sense ne "-") {
#$sense =~ s/(.*)(;|,).*/$1/g;
#chomp $sense;
#}
#	print $sense." after \n";
	my $mir_ID = $split[6];
	my $length = $split[7];
	
#warn Dumper \@split;	 
#-----files initialization -----
	my $out = $ARGV[1];
	$out =~ s/(.*)\.bed/$1/g;
	open my $OUT, '>>', "$out.hairpin_loci.fasta";
#-----Positive strand -----
	if ($sense eq "+") {		
		my $string = substr $seqs{$chr}, ($start), ($end-$start);
		$string = uc $string ; 
		print " La secuencia completa es $string\n";
#		chrY_Cluster_65_PRLG4_2477232_2477295
	#	chr1	156390123	156390230	hsaP-mir-9	 214	+	MI-NHSA	108	
		my $hsa_mir = ">".$chr."_".$start."_".$end."_".$mir."_".$sense."_".$mir_ID."\n".$string."\n"; # sequencia en +
		print $OUT $hsa_mir;
#-----negative strand -----	
       } 
	if ($sense eq "-") { 
#exact extraction 
                my $string = substr $seqs{$chr}, $start, ($end-$start);
		print " La secuencia completa es $string no reverse \n";
        	$string =~ tr/AGCTagct/TCGAtcga/;       
		my $stringr = uc $string; 
		print " La secuencia completa es $stringr compl \n";
	 	$stringr = reverse $stringr;	
		print " La secuencia completa es $stringr reverse \n"; 
       		my $hsa_mir = ">".$chr."_".$start."_".$end."_".$mir."_".$sense."_".$mir_ID."\n".$stringr."\n"; # sequencia en +
		print $OUT $hsa_mir;
                        } 
		
		
      } # end while

exit;
