tempids=()
tempids=$(cut -d '_' -f 1  BASH/grep_lists_example.txt)
time ( for f in ${tempids[@]}; do grep "^"$f","  $1; done | cut -d ',' -f 7  | sort | uniq -c )