#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp;
use Math::NumberCruncher;


#my $forks = shift @ARGV;
#my $line_count = `wc -l  $ARGV[0] | awk '{print \$1}'`;
#my $parts = ( int($line_count/$forks) + 1) ;

my (%total, %count);
my @dup_seqs = read_file($ARGV[1]);
chomp @dup_seqs; 
my %dup_seqs = map { $dup_seqs[$_] => "" } 0..$#dup_seqs;
@dup_seqs = (""); 
#my $pm = Parallel::ForkManager->new($forks);
#$pm->run_on_finish( sub {
#my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;
# %Bed = ( %$data_structure_reference , %Bed) ;
# } );
#my $inf_limit = 0;
#
#my @coordinates;
#for my $i (1 .. $forks) {
#my $sup_limit =  $i * $parts;
#push @coordinates, $inf_limit."_".$sup_limit;
#$inf_limit = $sup_limit + 1 ;
#$sup_limit =  $parts / $i;
#}

#Parallel:
my $start = time ;
my $seq_number = 1; 
#for my $i (1 .. $forks) {
#my @coor =  split /_/,  $coordinates[$i -1];
#my $inf_limit = $coor[0]  ;
#my $sup_limit = $coor[1];
#print $inf_limit." vs  $sup_limit\n";

#open(FastqTab, "awk -v lim_inf=$inf_limit -v lim_sup=$sup_limit '{if (NR > lim_inf && NR < lim_sup ) print }' $ARGV[0] | ");
open(FastqTab, "$ARGV[0]");

my $out = $ARGV[0];
$out =~ s/\/?(.*)_fastqtab\.txt/$1/g;
open my $OUT, '>', "$out.reduced.fastq";
open my $OUT2, '>', "$out"."_reduced_fastqtab.txt";
        while (<FastqTab>){
        my $fqtab = $_;
        chomp $fqtab;
        my @split = split /\t/, $fqtab;
	 	if (defined $dup_seqs{"$split[0]"}) { 	
		push @{ $total{"$split[0]"} }, $split[2]; 	
		$count{$split[0]} ++; 
		} else { 
		$seq_number ++;
		print $OUT "\@$out"."_".$seq_number."_1\n".$split[0]."\n+\n".$split[2]."\n";		
	        print $OUT2 "\@$out"."_".$seq_number."_1\t".$split[0]."\t+\t".$split[2]."\n";

		}
	} 

foreach my $seq (keys %total) {
$seq_number ++; 
my (%mean_quality_strand) ;
my  $qval_strand;
	foreach my $qval  ( @{ $total{$seq} } ) {
	my @qval = split //, $qval;
	for my $i (0 ..  (length($seq)-1)) {
	my $number = ((ord $qval[$i]) - 59)  ;
	push @{ $mean_quality_strand{$i} } , $number;
				      }
			      			}	 	

#Solexa encoding
#echo 0 | perl -ne 'my $asci = $_ + 59 ; print chr $asci ; print "\n";'
#echo \; | perl -ne 'my $asci = ord $_ ; print ($asci - 59); print "\n";'

	for my $i (0 .. (length($seq)-1)) {
	my @mean =  @{ $mean_quality_strand{$i} }  ;
	my $char = int(Math::NumberCruncher::Mean(\@mean)) + 59  ;
	$char = chr($char);
	$qval_strand .= $char ;
				      }
 
print $OUT  "\@$out"."_".$seq_number."_".$count{$seq}."\n".$seq."\n+\n".$qval_strand."\n";
print $OUT2 "\@$out"."_".$seq_number."_".$count{$seq}."\t".$seq."\t+\t".$qval_strand."\n";
} 
my $duration = (time - $start);
print $duration."s\n";
