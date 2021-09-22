#bash test_cluster_identity.sh hairpin_v21 hsa-mir-219a-2 hsa-mir-219b
#while read clus; do   mir=`echo $clus | awk 'gsub("_"," ",$2) {print $2}'  `; bash test_cluster.sh hairpin_v21 $mir ; done < ../Data/Mirbase_Seq/B_clust/hairpin_v21.hsa.Ti.clus; awk -F'\t' '{if ($2 < 100) print}' < hairpin_v21.clusters_statistcs.txt  > hairpin_v21.negative_clusters.txt; bash test_cluster_negative_sense.sh hairpin_v21 hairpin_v21.negative_clusters.txt

database=`echo $1`
total=("${@:2}")

bash test_cluster.sh $database ${total[@]} 
awk -F'\t' '{if ($2 < 100) print}' < $database.clusters_statistcs.txt  > $database.negative_clusters.txt
bash test_cluster_negative_sense.sh $database  $database.negative_clusters.txt
