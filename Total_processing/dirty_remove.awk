zcat $1 | awk 'OFS="\n"{header = $1; getline seq ; getline qhearder; getline qseq; print header,substr(seq,1,23),"+",substr(qseq,1,23)}' > $2"_dr.fq"
