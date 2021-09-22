#!/usr/bin/perl

##Routine to find non-orthologs identified miRNAs seqs taht have high blast values on the hg19 genome


#input 1
#chr15	80873444	80873580	hsa-mir-5572	 272	+	MI0019117	137
#chr15	81134319	81134414	hsa-mir-549a	 190	-	MI0003679	96
#chr15	81289758	81289814	hsa-mir-4514	 113	-	MI0016880	57
#chr15	83736087	83736167	hsa-mir-4515	 161	+	MI0016881	81
#chr15	85923827	85923893	hsa-mir-7706	 133	+	MI0025242	67
#chr15	86313727	86313809	hsa-mir-1276	 165	-	MI0006416	83
#chr15	86368866	86368961	hsa-mir-548ap	 190	+	MI0017875	96
#chr15	89151338	89151428	hsa-mir-1179	 180	+	MI0006272	91
#chr15	89155056	89155165	hsa-mir-7-2;hsa-mir-3529	 218	+,-	MI0000264;MI0017351(I)	110,78(32)
#chr15	89869970	89870041	hsa-mir-6766	 143	-	MI0022611	72
#chr15	89911248	89911337	hsa-mir-9-3	 178	+	MI0000468	90
#

#input 2 
#chr15   83424758        83424821        rno-mir-1839    6e-28   127     -
#chr15   83424761        83424820        eca-mir-1839    1e-25   119     -

#output 
#chr15  83736087        83736167        hsa-mir-4515     161    +       MI0016881       81
#chr15   83424758        83424821        rno-mir-1839    6e-28   127     -
#chr15   83424761        83424820        eca-mir-1839    1e-25   119     -
#chr15  85923827        85923893        hsa-mir-7706     133    +       MI0025242       67


# perl Bed_no-hsa_interesting.pl hg19_hairpin_v21.o_no-hsa.bed hg19_hairpin_v21.final.o.bed sense 


use strict;
use warnings;
use Data::Dumper;

##---------------------------------------To read BED file after name paralog removed ----------------------------------
open(BED, "$ARGV[0]");  #features bed
	my $name = $ARGV[0];
	$name =~ s/\.bed//;
	#print "$name \n"; 
        open my $OUT, '>', "$name".".unannotated.bed";

my ($chr,$start,$end,$sense,$P_start,$P_end,$feature,$P_chr, $P_feature, $P_sense);	
my %Bed;

    while (<BED>){
    my $bed = $_;
    chomp $bed;
    my @split = split /\t/, $bed;
	
	$chr = $split[0]; 
        $start = $split[1]; 
        $end = $split[2];

#	$Bed{$chr."_".$start."_".$end}=[ @split];
	$Bed{$chr."_".$start."_".$end."_".$split[5]}=[ @split];	


} ##end while1
#warn Dumper \%Bed; 

my @Ortholog; 
open(BED2, "$ARGV[1]");
	while (<BED2>){
        my $bed2 = $_;
    	chomp $bed2;
	my @split2 = split /\t/, $bed2;
        $P_chr = $split2[0]; 
        $P_start = $split2[1]; 
        $P_end = $split2[2];
	foreach my $key (keys %Bed){
#			 Ps < S &&  S  < Pe 
#	if ($P_chr eq $Bed{$key}[0] && $P_start <= $Bed{$key}[1] &&  $Bed{$key}[1] <= $P_end ) {  			 
	if ($P_chr eq $Bed{$key}[0] && $split2[5] eq $Bed{$key}[5]  && $P_start <= $Bed{$key}[1] &&  $Bed{$key}[1] <= $P_end ) {	
#	my $info =  $P_chr."\t".$Bed{$key}[1]."\t".$Bed{$key}[2]."\t".$Bed{$key}[3]."\t".$Bed{$key}[4]."\t".$Bed{$key}[5]."\t".$Bed{$key}[6].$Bed{$key}[7]."\n";
#        push  @Ortholog, $Bed{$key}[0]."_".$Bed{$key}[1]."_".$Bed{$key}[2]; 
	push  @Ortholog, $Bed{$key}[0]."_".$Bed{$key}[1]."_".$Bed{$key}[2]."_".$Bed{$key}[5];        
#		         S < Ps && Ps < E && E < Pe
#	} elsif ( $P_chr eq $Bed{$key}[0] &&  $Bed{$key}[1] <= $P_start && $P_start <= $Bed{$key}[2] &&   $Bed{$key}[2] <= $P_end  ) {
	} elsif ( $P_chr eq $Bed{$key}[0] && $split2[5] eq $Bed{$key}[5] &&  $Bed{$key}[1] <= $P_start && $P_start <= $Bed{$key}[2] &&   $Bed{$key}[2] <= $P_end  ) {
	
#	push  @Ortholog,  $Bed{$key}[0]."_".$Bed{$key}[1]."_".$Bed{$key}[2];
	 push  @Ortholog, $Bed{$key}[0]."_".$Bed{$key}[1]."_".$Bed{$key}[2]."_".$Bed{$key}[5];	
#			S < Ps && S < Pe && Pe < E 	
#       }  elsif ( $P_chr eq $Bed{$key}[0] &&  $Bed{$key}[1] <= $P_start && $Bed{$key}[1] < $P_end && $P_end  <= $Bed{$key}[2]  ) {
	}  elsif ( $P_chr eq $Bed{$key}[0] && $split2[5] eq $Bed{$key}[5] && $Bed{$key}[1] <= $P_start && $Bed{$key}[1] < $P_end && $P_end  <= $Bed{$key}[2]  ) {       
#	push  @Ortholog,  $Bed{$key}[0]."_".$Bed{$key}[1]."_".$Bed{$key}[2];
	 push  @Ortholog, $Bed{$key}[0]."_".$Bed{$key}[1]."_".$Bed{$key}[2]."_".$Bed{$key}[5];	

	} 
				   }
} #end while2 

my $Size_Bed = keys %Bed;
print "initial size of hash $Size_Bed\n";

foreach my $element (@Ortholog) { 
delete $Bed{"$element"} ; 
#print $element."\n";
}
 
$Size_Bed = keys %Bed; 
print "Number of Non anotated orthologus $Size_Bed\n"; 



foreach my $keys (sort keys %Bed) { 
	my $no_hsa_name =$Bed{$keys}[3]; 
	$no_hsa_name =~ s/(.*)-mir-.*/$1/g;
$Bed{$keys}[3] =~ s/(.*)-mir-(.*)/$1$2/g;
	my $new_name = "hsaP-mir-".$2; 
#	my $no_hsa_name = $1; 
my $info = $Bed{$keys}[0]."\t".$Bed{$keys}[1]."\t".$Bed{$keys}[2]."\t".$new_name."(".$no_hsa_name.")"."\t".$Bed{$keys}[4]."\t".$Bed{$keys}[5]."\t".$Bed{$keys}[6]."\t".$Bed{$keys}[7]."\n"; 
	print  $OUT $info;
#	 print  $info;
} 
#warn Dumper \@P_feature;
#warn Dumper \%Prlg_seqs; 
#foreach my $keys (sort keys %Prlg_seqs) { 
#print $OUT $Prlg_seqs{$keys}[0]; 
#}

exit;
