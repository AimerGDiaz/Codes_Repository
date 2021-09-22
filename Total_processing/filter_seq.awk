
awk 'OFS="\t"{if ($1 ~ /^3Noise*/ && $2 == "4" && length($10) >= 15) print $10}' $1 >miRNA_3prime_company_"$2"_cor.txt
awk 'OFS="\t"{if ($1 ~ /^3Noise*/ && $2 != 4 && length($10) >= 15) print $10}' $1 >miRNA_3prime_company_"$2"_hairpin.txt
