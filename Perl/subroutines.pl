use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

my @b = (1, 2, 3, 3, 4, 3);

my @results = myuniq(@b); 
foreach my $i (@results) {
print $i."\n";
} 

sub myuniq {
my @data = @_;
my @unique ;
my %seen;

foreach my $value (@data) {
   $seen{$value}++;
			  } 
@data = uniq @data; 

foreach my $value (@data)	 {
	 if ( $seen{$value} > 1 )  	    {
    push @unique, $value." ".$seen{$value}++;
  					    } else { 
	push @unique, $value; 
				 	    }
				}
return @unique ;
	   }

