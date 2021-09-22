#!/usr/bin/perl

##Routine to separate name redundancy & paralogs entires from uniq sequences 

# input hg19_hairpin_v20.o.bed
#chr1	30366	30503	hsa-mir-1302-10	 274	+	MI0015979	138
#chr1	30366	30503	hsa-mir-1302-11	 274	+	MI0015980	138
#chr1	30366	30503	hsa-mir-1302-2	 274	+	MI0006363	138
#chr1	30366	30503	hsa-mir-1302-9	 274	+	MI0015978	138
#chr2	114340536	114340673	hsa-mir-1302-3	 274	-	MI0006364	138
#chr2	208133999	208134148	hsa-mir-1302-4	 297	-	MI0006365	150
#chr7	18166843	18166932	hsa-mir-1302-6	 178	-	MI0006367	90
#chr8	142867603	142867674	hsa-mir-1302-7	 143	-	MI0006368	72
#chr9	30144	30281	hsa-mir-1302-10	 274	+	MI0015979	138
#chr9	30144	30281	hsa-mir-1302-11	 274	+	MI0015980	138
#chr9	30144	30281	hsa-mir-1302-2	 274	+	MI0006363	138
#chr9	30144	30281	hsa-mir-1302-9	 274	+	MI0015978	138
#chr9	100125836	100125963	hsa-mir-1302-8	 254	-	MI0006369	128
#chr12	113132839	113132981	hsa-mir-1302-1	 283	-	MI0006362	143
#chr15	102500662	102500799	hsa-mir-1302-10	 274	-	MI0015979	138
#chr15	102500662	102500799	hsa-mir-1302-11	 274	-	MI0015980	138
#chr15	102500662	102500799	hsa-mir-1302-2	 274	-	MI0006363	138
#chr15	102500662	102500799	hsa-mir-1302-9	 274	-	MI0015978	138
#chr19	71973	72110	hsa-mir-1302-10	 274	+	MI0015979	138
#chr19	71973	72110	hsa-mir-1302-11	 274	+	MI0015980	138
#chr19	71973	72110	hsa-mir-1302-2	 274	+	MI0006363	138
#chr19	71973	72110	hsa-mir-1302-9	 274	+	MI0015978	138
#chr20	49231173	49231322	hsa-mir-1302-5	 297	-	MI0006366	150
#chr5   159901409       159901490       hsa-mir-3142     163    +       MI0014166       82
#chr5   159901451       159901532       hsa-mir-3142     163    +       MI0014166       82


# taking from the input 2 hairpin_v20.hsa.clus the clusters info 
#cluster-1	hsa-mir-1302-10_hsa-mir-1302-11_hsa-mir-1302-2_hsa-mir-1302-3_hsa-mir-1302-9 
#hsa-mir-1302-4 (non clustered seq)
#hsa-mir-1302-5 (non clustered seq)
#hsa-mir-1302-1 (non clustered seq)
#hsa-mir-1302-8 (non clustered seq)
#hsa-mir-1302-6 (non clustered seq)
#hsa-mir-1302-7 (non clustered seq)

#output
#chr1   30366   30503   cluster-1    +       MI0015979       138
#chr2   114340536       114340673       cluster-1	274    -       MI0006364       138
#chr2   208133999       208134148       hsa-mir-1302-4   297    -       MI0006365       150
#chr7   18166843        18166932        hsa-mir-1302-6   178    -       MI0006367       90
#chr8   142867603       142867674       hsa-mir-1302-7   143    -       MI0006368       72
#chr5   159901409       159901490       hsa-mir-3142     163    +       MI0014166       82
#chr5   159901451       159901532       hsa-mir-3142     163    +       MI0014166       82

# perl Bed_filtering_name_prlg.pl hairpin_v21.hsa.clus hg19_hairpin_v21.o.bed
use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

##---------------------------------------To read BED file after name paralog removed ----------------------------------
open(Cluster, "$ARGV[0]");  #features bed

my %Clus;
    while (<Cluster>){
    my $clus = $_;
    chomp $clus;
    my @name = split /\t/, $clus;
    my @old_name = split / /, $name[1];	
    foreach my $old (@old_name) { 
    $Clus{$old} = $name[0];
    } 
	
} ##end while1

#warn Dumper \%Clus; 
open(BED, "$ARGV[1]");
	my $name = $ARGV[1];
       $name =~ s/\.bed//;
open my $OUT, '>', "$name".".clus.bed";

	while (<BED>){
	my $bed = $_;
	chomp $bed;
	my @split = split /\t/, $bed;	
	my $hsa_mir = $split[3];

#chr1	17369	17436	hsa-mir-6859-r-l1	135	-	MI-Redundancy	68

	if (defined $Clus{$hsa_mir}) { 
	my $info = $split[0]."\t".$split[1]."\t".$split[2]."\t".$Clus{$hsa_mir}."\t".$split[4]."\t".$split[5]."\t".$split[6]."\t".$split[7]."\n"; 
	print $OUT $info;
	} else { 
	print $OUT $bed."\n"; 
	}
		    }  
