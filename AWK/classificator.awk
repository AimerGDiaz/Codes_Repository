# Welcome my github readers, this an awk script commented, in reality this code can
# be excecuted as a one liner, even including the print of the file, but R markdown 
# does not handle all of the awk power, by now
#
# The  One-liner format
#
# awk 'NR>1{if(a[$2])a[$2]=a[$2]" and "$1; else a[$2]=$1;}END{for (i in a) print "The gene "i", is located on chromosome "a[i];}' 
#
# But I will explained as a script here
	 awk 'NR>1{       
	 if(a[$2]) a[$2]=a[$2]" and "$1
	 else a[$2]=$1} END  {for (i in a) 
	 print "The gene "i", is located on chromosome "a[i]}' $1  
