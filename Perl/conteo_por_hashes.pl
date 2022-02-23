#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Fatal qw(open close);

#--------------------------------------------Taller Perl uso de hashes para conteo de datos  ----------------------------
#  Conteo de elementos que conforman una estructura secundaria, via hash. Por Clara Bermúdez
#------------------------------------------------------------------------------------------------------------------------



#---------------------------Ejercicio -----------------------------------
# El argumento es test.dat ubicado en ../Data
#

open my $IN, "< $ARGV[0]"; # Apertura de archivo desde la entrada estandar


my %hash = (); # Declaramos nuestra variable tipo hash.


while(my $line = <$IN>){ # Acceso a cada linea del archivo de entrada
	chomp $line;
	my @value = split (//, $line);      # Subdivision de las lineas de entrada en caracteres
		for my $j (0 .. $#value)  { # Acceso a cada elemento del arreglo. Otra forma de escribir nuestra estructura de control for en Perl.
			my $symbol = $value[$j]; # asignamos cada elemento del arreglo a la varibale $symbol	

				if ($symbol eq "(") {
					$hash{$symbol} ++; 
			}

			elsif ($symbol eq ")") {
				$hash{$symbol} ++;
			}

			elsif ($symbol eq ".") {
				$hash{$symbol} ++;
			}

		} # end for my j

	warn Dumper \%hash;                 # Given a list of scalars or reference variables, writes out their contents in perl syntax. The references can also be objects. The content of each variable is output in a single Perl statement. Handles self-referential structures correctly. (CPAN)   


		foreach my $key (keys %hash) {    # If you whish to iterate over (that is, examine every element of) an entire hash, you could use foreach function

			print "Aca imprimo la clave $key y aqui su valor acumulado $hash{$key}.\n";

		} # end foreach

	%hash = (); # Es necesario dejar de nuevo vacia para reiniciar la hash  en cada iteración del ciclo while 

}  # end while



close $IN;
