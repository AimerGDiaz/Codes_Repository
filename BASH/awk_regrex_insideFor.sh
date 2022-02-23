tempids=()
tempids=$(cut -d '_' -f 1  BASH/grep_lists_example.txt)
time ( for f in ${tempids[@]};  do  awk -F',' '/^'$f',/{print $7}' $1 ; done | sort | uniq -c  ) # $1 ~ /^'$f'$/ equivalent