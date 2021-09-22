#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Bio::SeqIO;
use List::MoreUtils qw(uniq); 
my $in = Bio::SeqIO->new( -file => $ARGV[0] ); # locations of theq = $in->next_seq) {

                                               #original fasta file
#my $out = Bio::SeqIO->new( -file => ">$ARGV[1].fa", -format =>
#    'Fasta'); # save key.fasta
#my ($feature,$sense,  %uniq_seqs, %prlg_seqs);
#open(Filter, "$ARGV[1]");
#	while (<Filter>){
#	my $filter = $_;
#	chomp $filter;
#	my @split = split /\t/, $filter;
#	$feature = $split[0]; 
#	$sense = $split[1];
#print $feature."\n";
my $out = $ARGV[0];
$out =~ s/(.*)\.hairpin_loci.fasta/$1/g;
open my $OUT, '>>', "$out.hairpin_loci_uq.fa"; 
open my $OUT2, '>>', "$out.real_prlg.bed";
my (%total, %uniq_seqs, %prlg_seqs, %total_seqs);
 
		while (my $seq = $in->next_seq) {
#		foreach (my $seq = $in->next_seq) {		
#    print $seq->id . "\n";
		my $sequence =  uc $seq->seq;
		$seq->seq($sequence);    	
		my @split2 =  split /_/, $seq->id;   
	#	if ($split2[4] eq "MI" ) { 
	#	$split2[4] = $split2[4]."_".$split2[5];
	#	$split2[5] = $split2[6];
	#	delete $split2[6] ;
	#	} 
#		$total{$split2[3]."_".$split2[5]} ++ ; 		
#		$total{$split2[3]."_".$split2[5]} = $total_seqs{$seq->seq} ++; 	
#		$total{$split2[3]."_".($split2[2]-$split2[1])} = $total_seqs{$seq->seq} ++; 	
# 	        $total{$seq->seq} = [$total_seqs{$seq->seq} ++ ,  $split2[3] ] ;
#		push @{  $total{$split2[3]} }, $total_seqs{$seq->seq} ++;
#		my $id = join("_" , @split2[0..4]); 		
		push @{ $total{$split2[3]} },  $seq->seq."|".$seq->id ;   # $seq->id;
#		$total_seqs{$seq->seq} ++;
#		print $seq->seq()."\n";
#	        $out->write_seq($seq);
#								     } 	        
#					   	}
			}
#foreach my $id ( keys %total ) { 
#if ($total{$id} > 1) { 
#
#$prlg_seqs{$total{$id}};    
#} else { 
#
#$uniq_seqs{$total{$id}};
#}  
#}
#warn Dumper \%total; 
foreach my $ele (keys %total) {
my @sub_array = @{ $total{$ele} } ;
	if ($#sub_array > 0 ) {
	my %reduced_prlg; 
	foreach my $seq (@sub_array) { 

	my @real_diff = split /\|/, $seq; 
	push @{ $reduced_prlg{$real_diff[0]} } , $real_diff[1]; 
				     }
# warn Dumper \%reduced_prlg;
	my $count = 1;
	foreach my $real_prlg (keys %reduced_prlg) { 
	print $OUT ">".$ele."-l".$count."\n".$real_prlg."\n";
	my @coordenates = @{ $reduced_prlg{$real_prlg} } ;
		foreach my $pos (@coordenates){ 	
		#chr6_165823090_165823139_hsa-mir-7641-lk_+_MI-MinorLK'
		my @split2=  split /_/, $pos; 
		$split2[3] = $ele."-l".$count; 
		my $out =  join("\t", @split2)."\n";
		print $OUT2 $out;
		}
	$count ++;
					           }
	

			      
	} else { 
	my @real_diff = split /\|/, $sub_array[0];
	my @split3 =  split /_/, $real_diff[1];
#	($split3[4], $split3[5]) = ($split3[5], $split3[4]);
	my $out =  join("\t", @split3)."\n";
	print $OUT ">".$ele."\n".$real_diff[0]."\n"; 
	print $OUT2 $out;	
	
		        }

	} 
#	if ($#fasta > 0 ) { 
# 	warn Dumper \%total;
#	my $count = 1;
#	my @cor_bed =  grep $ele, @bed;
#	#warn Dumper \@cor_bed; 
#	
#		foreach my $bed_line (@cor_bed) { 
#	  	my @split3 =  split /_/, $bed_line;
#		$split3[3] = $ele."-l".$count; 
#		($split3[4], $split3[5]) = ($split3[5], $split3[4]); 
#		my $out =  join("\t", @split3)."\n"; 
#		print $OUT2 $out;	
#		$count++;
#		
#		}
#	$count = 1;
#	foreach my $ele2 ( @fasta) {
#	print $OUT ">".$ele."-l".$count."\n".$ele2."\n";
#	$count ++; 
#		}
#	} else { 
#	my @cor_bed =  grep $ele, @bed;
#	#warn Dumper \@cor_bed; 
#	
#	foreach my $bed_line (@cor_bed) { 
#  	my @split3 =  split /_/, $bed_line;
#	($split3[4], $split3[5]) = ($split3[5], $split3[4]);
#	my $out =  join("\t", @split3)."\n"; 
#	print $OUT2 $out;	
#					} 
#	foreach my $ele2 ( @fasta) { 
#	print $OUT ">".$ele."\n".$ele2."\n";
#  		    	           }
#	       }
#	
#		        }
#   'hsa-mir-3118-r' => [
#                               'CACACTACAATAATTTTCATAATGCAATCACACATAATCACTATGTGACTGCATTATGAAAATTCTTGTAGTGT|chr1_142667289_142667363_hsa-mir-3118-r_+_MI-Redundancy',
#                                'CACACTACAATAATTTTCATAATGCAATCACACATAATCACTATGTGACTGCATTATGAAAATTCTTGTAGTGT|chr1_143424141_143424215_hsa-mir-3118-r_-_MI-Redundancy',
#                                'CATACTACAATAATTTTCATAATGCAATCACACACAATCACCGTGTGACTGCATTATGAAAATTCTTCTAGTGT|chr15_21038124_21038198_hsa-mir-3118-r_+_MI-Redundancy',
#                                'CATACTACAATAATTTTCATAATGCAATCACACACAATCACCGTGTGACTGCATTATGAAAATTCTTCTAGTGT|chr15_22049274_22049348_hsa-mir-3118-r_+_MI-Redundancy',
#                                'CACACATACAATAATATTCATAATGCAATCACACACAATCACCATGTGACTGCATTATGAAAATTCTTCTAGTGT|chr21_15017096_15017171_hsa-mir-3118-r_-_MI-Redundancy'
