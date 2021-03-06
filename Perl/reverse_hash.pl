#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %chr2qual = ('h' => 71,'E' => 36,'6' => 21,'U' => 52,'e' => 68,'1' => 16,'c' => 66,'Q' => 48,'K' => 42,
':' => 25,'|' => 91,'7' => 22,'g' => 70,'z' => 89,'4' => 19,'V' => 53,'_' => 62,'.' => 13,'m' => 76,'s' => 82,
'^' => 61,'/' => 14,'G' => 38,'#' => 2,'[' => 58,'j' => 73,'y' => 88,'*' => 9,'}' => 92,'a' => 64,'i' => 72,'N' => 45,
'$' => 3,',' => 11,'S' => 50,']' => 60,'<' => 27,'+' => 10,'!' => 0,'O' => 46,'l' => 75,'X' => 55,'5' => 20,'A' => 32,';' => 26,
'\'' => 6,'(' => 7,'3' => 18,'I' => 40,'0' => 15,'f' => 69,'B' => 33,'2' => 17,'q' => 80,'R' => 49,'W' => 54,'?' => 30,'Y' => 56,'v' => 85,
'k' => 74,'Z' => 57,'{' => 90,'"' => 1,'J' => 41,'>' => 29,'P' => 47,'%' => 4,'x' => 87,'t' => 83,'u' => 84,'n' => 77,'p' => 79,'@' => 31,
'8' => 23,'\\' => 59,'F' => 37,'T' => 51,'=' => 28,'L' => 43,'9' => 24,'C' => 34,'D' => 35,'b' => 65,'r' => 81,'~' => 93,'o' => 78,'M' => 44,'d' => 67,
'w' => 86,'&' => 5,'-' => 12,')' => 8,'`' => 63,'H' => 39, ); 

my %chr2qual_r = reverse %chr2qual; 
warn Dumper \%chr2qual_r; 

