#!/bin/bash
# Welcome my github readers, this an awk script commented, in reality this code can
# be excecuted as a one liner, even including saving the process on a new file, but R markdown 
# does not handle all of the awk power, by now
#
# The  One-liner format
#
# awk 'NR>1{if(a[$2])a[$2]=a[$2]" and "$1; else a[$2]=$1;}END{for (i in a) print "The gene "i", is located on chromosome "a[i];}' 
#
# But I will explained as a script here
#	 awk 'NR>1{
	# Omit the first line	
#	 if(a[$2]) a[$2]=a[$2]" and "$1
	# make an array with the second field (column by default splitted by tab)
	# and if the element is already on the array, add extra attributes (first column) as a coment separated with ` and `
#	 else a[$2]=$1} END  {for (i in a)
# if the element is not on the array, save it as a new element with its related attribute
#	 print "The gene "i", is located on chromosome "a[i] }' $1
	 # Finally a for loop for print array elements with a presenting words
<<<<<<< HEAD
	 # Without commetns clean like this: 
	 awk 'NR>1{ if(a[$2]) a[$2]=a[$2]" and "$1
	 else a[$2]=$1} END  {for (i in a) 
	 print "The gene "i", is located on chromosome "a[i]}' $1  
=======
	 #If you have noted, awk allow me to introduce as many spaces, jumps, and still run :O
	 # It does not have to be clean like this: 
	# awk 'NR>1{       
	# if(a[$2]) a[$2]=a[$2]" and "$1
	# else a[$2]=$1} END  {for (i in a) 
	# print "The gene "i", is located on chromosome "a[i]}' $1  
>>>>>>> 489fd555b64381d403532935b51b37a29629ccef
