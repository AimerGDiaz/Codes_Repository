#bash test_cluster_identity_massive.sh database clus_file 
#bash test_cluster_identity_massive.sh clus_file 
database=`echo $1`
#database="hg19_hairpin_complete" or "mature_mix"
while read clus
do
mir=`echo $clus | awk 'gsub("_"," ",$1) {print $1}'  `
bash test_cluster.sh  $database $mir
 done < $2

awk -F'\t' '{if ($2 < 100) print}' < $database.clusters_statistcs.txt  > $database.negative_clusters.txt

bash test_cluster_negative_sense.sh $database $database.negative_clusters.txt


rm $database.negative_clusters.txt

#awk -F'\t' 'OFS="\t" {cor=$2; gsub(" .*","",cor);  if (cor == "100" && $4 == "+" ) print $0 }' hg19_hairpin_complete.clusters_statistcs.txt  > ../Results/hg19_hairpin_complete.pos_clus.txt
#awk -F'\t' 'OFS="\t" {cor=$2; gsub(" .*", "" ,cor); if (cor == "100" && $4 == "-" ) print $0 }' hg19_hairpin_complete.clusters_statistcs.txt  > ../Results/hg19_hairpin_complete.negative_clus.txt
awk -F'\t' 'OFS="\t" {cor=$2; gsub(" .*", "" ,cor); if (cor == "100"   ) print $0 }' $database.clusters_statistcs.txt  > ../Results/$database.clus.txt

rm $database.clusters_statistcs.txt

