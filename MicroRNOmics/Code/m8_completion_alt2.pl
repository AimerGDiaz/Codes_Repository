 #!/usr/bin/perl 
 use warnings;
 use strict;
 use File::Basename;
 use Parallel::ForkManager;
 use Data::Dumper; 

my %grupos1;
my %grupos2;
my $forks = shift @ARGV;



my $pm = Parallel::ForkManager->new($forks);
$pm->run_on_finish( sub {
my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;
}); 
open my $IN, '<', $ARGV[0];
#print $inf_limit." vs  $sup_limit\n";
#open(IN, "awk -v lim_inf=$inf_limit -v lim_sup=$sup_limit '{if (NR > lim_inf && NR < lim_sup ) print }' $ARGV[0] | ");
	while (my $line = <$IN>)
		{
		chomp $line;
		my @split = split /\t/, $line;
		my @split2 = split /_/, $split[0];
		 
#mmu-mir-200b_MI0000243_Mus_musculus_miR-200b_stem-loop	chr1	94.29	70	4	0	1	70	1102496	1102565	7e-22	 107	100
#        if ($split[2] == 100) {
    
        my $id1 = join ("\t", @split);
        if (!defined $grupos1{$id1}) {
        $grupos1{$id1}= [];
        
        } #close defined
        
        push @{$grupos1{$id1}}, [$split2[0],$split[3]]; #hash value 

        
 #       } #if
	}# close while
close $IN;
my $line_count = `wc -l  $ARGV[1] | awk '{print \$1}'`;
my $parts = ( int($line_count/$forks) + 1) ;
my $inf_limit = 0;
my @coordinates;
for my $i (1 .. $forks) {
my $sup_limit =  $i * $parts;
push @coordinates, $inf_limit."_".$sup_limit;
$inf_limit = $sup_limit + 1 ;
$sup_limit =  $parts / $i;
}
my $name = basename("$ARGV[0]"); 
open my $OUT, '>', "/scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/$name.coincidence";
Parallel:
for my $i (1 .. $forks) {
my $pid = $pm->start($i) and next Parallel;
print "loop $i\n";
my @coor =  split /_/,  $coordinates[$i -1];
my $inf_limit = $coor[0]  ;
my $sup_limit = $coor[1];

print $inf_limit." vs  $sup_limit\n";
open(IN2, "awk -v lim_inf=$inf_limit -v lim_sup=$sup_limit '{if (NR > lim_inf && NR < lim_sup ) print }' $ARGV[1] | ");
#open my $IN2 , '<', $ARGV[1];
while (my $length = <IN2>) {
chomp $length;
my @split2 = split /\t/, $length;
#ath-MR169m	MI0000987	212
my $id2 = join ("\t", @split2);
   if (!defined $grupos2{$id2}) {
        $grupos2{$id2}= [];
        
        } #close defined
        
        push @{$grupos2{$id2}}, [$split2[0],$split2[1], $split2[2]]; #hash value 
      
} #close while

close IN2;

#warn Dumper \%grupos2; 

foreach my $key1 ( sort keys %grupos1 ) {
for my $element1 ( @{ $grupos1{$key1} } ) {    #derefrence
foreach my $key2 ( sort keys %grupos2 ) {
            for my $element2 ( @{ $grupos2{$key2} } ) {
                if ($element1->[0] eq $element2->[0]
                    && $element1->[1] == $element2->[2])
                {

                   print $OUT "$key2\t$key1\n";
#		print "$key2\t$key1\n";
                } ## end if
            }    #end foreach key1
        }
    }    #end foreach key2
} #end foreach key1
#print "$out is done\n";
%grupos1 = (); #empty hash
%grupos2 = (); #empty hash
close $OUT;

 $pm->finish($i);
}
$pm->wait_all_children;

