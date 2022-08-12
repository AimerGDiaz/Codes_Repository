Scripts and Oneliners explained
================
Aimer G. Diaz

<!--- Central Folfer
Github extras 

https://github.com/gayanvoice/github-profile-views-counter

Sintaxis propia de github markdown https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

Sintaxis for all the R markdowns in general https://bookdown.org/yihui/rmarkdown-cookbook/raw-latex.html 
https://bookdown.org/yihui/rmarkdown/language-engines.html

El tema de las licencias https://gist.github.com/lukas-h/2a5d00690736b4c3a7ba

Cuando lanze los pauetes tanto de deteccion de fragmentos como el script de reduccion de librerias
https://vlado.ca/blog/perl-app.html
https://docs.github.com/en/enterprise-server@2.22/packages/quickstart  
https://github.com/LorenzoTa/step-by-step-tutorial-on-perl-module-creation-with-tests-and-git/blob/master/tutorial/tutorial-english.md
https://fpm.readthedocs.io/en/v1.13.1/intro.html
https://github.com/jordansissel/fpm/pull/876

git hub pulling pushing and difference https://github.blog/2011-10-21-github-secrets/ 

SQL too https://www.red-gate.com/hub/product-learning/sql-source-control/github-and-sql-source-control 

Wikis en github https://guides.github.com/features/wikis/

--->

Welcome to my code repository, most or all of it I’ve learned in a very
inclusive sense of the word (including copy from internet forums),
following this beautiful logic of public domain I’ve made these notes
available, the idea it’s to have a server-independent repository, a
repository on the cloud, or should I say, on the bottom of the ocean
with several copies in several sites of the world, for today and maybe,
just maybe, even available on a post-global ecological disaster era,
available physically but not online.

I will try to indicate here the structure of all the folders of this
repository, each folder anyway will have more information with its own R
markdown. The idea of this out of site file is to indicate meta-folders
features, like links for indicate where the same code is used in the
exactly same way, or when I made a change for any reason for a specific
project (all of them would be on bioinformatics next-generation data
analysis, my main expertise).

As an example a very basic but useful code I wrote in bash syntax and I
use it for every project, it’s a code I call `sra_download.sh`, which
take a given list (or even better with the SRA Run selector table from
Sequence Read Archive (SRA)) and download differentiating, if the input
table indicate, if the fastq file is single or paired end. Let’s explore
the latest data set I was working when I wrote this document, from the
[SRA
site](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP190362&o=acc_s%3Aa):

| SRA_Code   | Sequence_Tech | Cell_location_stage         | Strain     | Total_Sequences | Length  | Source          | ServerName               |
|------------|---------------|-----------------------------|------------|-----------------|---------|-----------------|--------------------------|
| SRR8859642 | PAIR END      | Procyclic                   | EATRO 1125 | 85,827,714      | 125/125 | Cooper2019_gRNA | Cooper2019_gRNA_E1125PC  |
| SRR8859640 | PAIR END      | Bloodstream                 | EATRO 1125 | 79,132,567      | 125/125 | Cooper2019_gRNA | Cooper2019_gRNA_E1125BS  |
| SRR8859641 | PAIR END      | Bloodstream + Procyclic MIX | EATRO 1125 | 148935513       | 125/125 | Cooper2019_gRNA | Cooper2019_gRNA_E1125Mix |

The first version of the file is [on the master thesis codes
folder](Total_processing/Download_script.sh), however this version did
not has the option to download the SRA considering if it’s single or
paired end. The latest version of it does and it’s on the [Trypanosoma
repository](https://github.com/AimerGDiaz/Trypanosomes_RNA_editing).

------------------------------------------------------------------------

# Codes repository

In order to start, I will comment here sections of the codes and the way
I apply them to solve specific problems, in other terms, here what you
will find is a selection of commented and finished codes in bash, awk,
perl, python, R and Latex languages, plus R markdowns files explaining
these codes using small toy data sets. Finally in this document you can
also find useful one liners commented, also with toy examples.

Let’s start with the one-liners, it’s true they are not the best
solution, however they are fast, they avoid us to write or re-adapt
whole blocks of code to particular solutions, they are modular and
somehow, they are like culture, beyond if it’s recommended or not to use
them, some people love them and I am one of those. I will introduce them
first, because I always started with them to explore the original data,
already made analysis, new formats, supplementary material, etc.

## Awk

Awk codes are my favorite, the one liners are extreamlly useful, fast,
weird but incredible, but they can be adapted as bash codes and even
using in parallel computing by the amazing GNU parallel software with
minor modifications as I will show here. But let’s start, the selected
awk codes and toy data samples will be [here](AWK/README.md).

### Generalities of my awk codes

All the languague I’ve mentioned before will have the same structure for
this section: main applications of the main control structures (<for>,
<while> and <if>), combinations of control structures and most employed
codes so far. Before enter to control structres, there are awk specific
features important to highlight:

#### Printing header line -Begin command-:

Generating a header row, while modifying the content that follows, for
instance, by substituting an element of a field:

``` bash
awk -v OFS="\t" -F'\t'  'NR==1 {print "ID","NGenes","Genes"} {split($2,a," "); gsub(" ",",", $2);print $1,length(a),$2}'  
```

In case there is already a header line, a new one can be generated as
follow:

``` bash
awk -F','  -v n=1 -v OFS="\t" 'NR==1 {print "#chrom","pos","rsid","ref","alt","neg_log_pvalue","maf","score","alt_allele_freq" } NR>2{print "Chr"$1,$2,"rs"n,"A","T","0.01",$3,$4,"."} ' GWAS_CaMV.csv 
```

The newly generated line count as a 1, then to ignore the previous
header we would need `NR>2`

#### Reducing multiples lines into a single line to analyse -getline command-:

Awk can work not only line per line, it’s able to integrate as a unit of
analysis files which format might have a specific set of lines per
element, for instance 2 lines describe a single sequence in a fasta
format or 4 lines a fastq file, how to integrate those lines to a single
unit of analysis?. The `getline` awk function it’s a faster way to make
it, meaning very simple and useful one-liners of awk might be used for
files like this.

First example a Fastq to Fasta file converter using the next one-liner:

``` bash
awk ' BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; print ">"header,seq}' $1 > $name.fa
```

A very similar task can be achieved with a derivative code, like change
the headers of multi-fasta file for a shorter version of it or simply to
add the sequence length for blast output filters, which can be achieved
using:

``` bash
awk  ' BEGIN {OFS = "\n"} {header = $0 ; getline seq  ; gsub(/;Ant.*/,"",header); header=header";length="length(seq);  print header,seq}' $1 > $name.fa
```

This code is integrated to a function of change suffix on the code
called [fq2fa.sh](AWK/fq2fa.sh). The function getline must be call as
many line we want to integrated in a single unity of analysis.

#### Focus on user defined lines `NR%` command

Individual read length and total quantity of nucleotides

``` bash
echo -ne "@seq1\nACGAGGAGGACGTACGTAGCTAGCGAGCGATCTATCGATGCTAC\n+\nACGAGGAGGACGTACGTAGCTAGCGAGCGATCTATCGATGCTAC\n@seq2\nACGAGCGAGCATCGAGCTAGCTGACTAGCTTAGCTATCG\n+\nnCGAGCGAGCATCGAGCTAGCTGACTAGCTTAGCTATCG\n"  > file.fastq
awk '{ if(NR%4==2){print length($0);} }'  file.fastq  

awk 'BEGIN{sum=0;}{if(NR%4==2){sum+=length($0);}}END{print sum;}'  file.fastq 
```

------------------------------------------------------------------------

#### Change delimiters, regrex in awk 101:

A related issue to the previous one it’s the case when you want to
change the field delimiter of certain lines, but not all, a typical
example in bioinformatics of this task it’s transform a multi-fasta file
with multiple jump lines into a single line per sequence, graphically:

From

    >1
    ACCCAGAGAGTGAG
    ACCAACACACAGTT`

To

    >1
    ACCCAGAGAGTGAGACCAACACACAGTT`

To make it we can use the regrex expression integrated with the
simplified if control loop of awk:

``` bash
awk '/^>/{printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' $1 > $1.ol.fa 
```

On this awk-oneliner, we first select those lines who do start with \>
`/^>/` anything in between would be separated only by one jump of line
per each `^>` line found. This code it’s called
[oneliner.awk](AWK/oneliner.awk)

#### Read files separated by comma, -F and gsub commnad

There is not better fast and time-saving file separator as awk’s -F
commnad, let’s start with a common issue analyzing common bioinformatics
files as CSV files, haven’t you face that annoying CSV files with text
in the same field where is also commas there?, usually this :

NCBI gen omnibus dataset has such problem and awk has the solution:

``` bash
awk -F',' 'OFS="\t"{gsub("\"","",$0);gsub(" |, ","_",$0);print $1,$2,$4,$8}' $1 
```

``` bash
cat AWK/sentence.temp 
cat AWK/separator.awk
#Run in terminal 
# dos2unix AWK/separator.awk
bash AWK/separator.awk AWK/sentence.temp "gsub"
```

    ## "PRJNA272807","In plants, decapping prevents RDR6-dependent production of small interfering RNAs from endogenous mRNAs",3702,"Arabidopsis thaliana","Eukaryota; Plants; Land Plants",,"Primary submission","Transcriptome or Gene expression","Yes","Yes","2015-01-16"
    ## if [ "$2" == "gsub" ]
    ## then
    ## 
    ## echo -ne "\nExtracting only the fields 1,2,4 and 8 \n\n"
    ## 
    ## awk -F',' 'OFS="\t"{gsub("\"","",$0);gsub(" |, ","_",$0);print $1,$2,$4,$8}' $1 
    ## elif [ "$2" == "F" ]
    ## then 
    ## 
    ## awk -F'(,"|",)' 'OFS="\t"{gsub(" ","_",$0); print $1,$2,$4,$8}' $1 | tr -d '"'
    ## 
    ## elif [ "$2" == "SRA" ]
    ## then
    ## 
    ## echo -ne "\nExtracting most informative fields \n\n"
    ## 
    ## awk -F'(,"|",)' -v OFS="," '{ print $1,$5 }' $1  | awk -F',' -v OFS="," '{gsub(" ","_",$0);gsub("ncRNA-Seq","smallRNA-Seq",$2); print $1,$16,$2,$19,$11,$24,$20,$10,$13,$3,$4,$26}'
    ## 
    ## elif [ "$2" == "IF" ]
    ## then
    ## 
    ## awk -F'(,"|",)' -v OFS=","  '{gsub(" ","_",$0); print $1,$5 }' $1  | awk -F',' -v OFS="," '{if (NR == "1") {$10=$11=$12=""; print $1,$19,$2,$22,$14,$27,$23,$13,$16,$3,$4,$29 } else {gsub("ncRNA-Seq","smallRNA-Seq",$2);print  $1,$16,$2,$19,$11,$24,$20,$10,$13,$3,$4,$26}}'
    ## 
    ## fi
    ## Extracting only the fields 1,2,4 and 8 
    ## 
    ## PRJNA272807  In_plants_decapping_prevents_RDR6-dependent_production_of_small_interfering_RNAs_from_endogenous_mRNAs  Arabidopsis_thaliana    Transcriptome_or_Gene_expression

Another great solution is by using awk -F command, which allow us to
split fields using regrex expression, in this case :

``` bash
awk -F'(,"|",)' 'OFS="\t"{gsub(" ","_",$0); print $1,$2,$4,$8}' $1
```

A more complicated case comes from SraRunTable.txt formatting, which
might have at the same time, comma separated fields, but not "
demarcation, a annoying solution is to homogenize the header and the
fields with such characteristic, as here the original file now includes
" in the header, to be able to run with the same syntax

``` bash
head -n 1 AWK/SraRunTable_edited.txt 

bash AWK/separator.awk AWK/SraRunTable_edited.txt "SRA"
```

    ## Run,Assay Type,AvgSpotLen,Bases,BioProject,BioSample,Bytes,Center Name,Consent,"DATASTORE filetype","DATASTORE provider","DATASTORE region",days_past_infection,ecotype_background,Experiment,Genotype,Instrument,Library Name,LibraryLayout,LibrarySelection,LibrarySource,Organism,Plant_age,Platform,ReleaseDate,Sample Name,source_name,SRA Study,treatment
    ## 
    ## Extracting most informative fields 
    ## 
    ## Run,LibraryLayout,Assay_Type,Organism,ecotype_background,source_name,Plant_age,days_past_infection,Genotype,AvgSpotLen,Bases,treatment
    ## SRR17697100,PAIRED,smallRNA-Seq,Arabidopsis_thaliana,Col-0,rosette,39_days,21,dcp5-1/rdr6-15,102,4009784628,CaMV_(CM184I)_infected

For this situation a double separation using both previous criteria:

#### Text reformatting or search and save function //

The previous detailed command `getline`, applied on structured format
might help to reformat complex files in simpler single lines formats.
However if the text have not a regular and constant number of lines per
object, this approach is not longer suitable. As alternative, awk has a
saving command for regrex search, who might use conserved features of
each entry as an organizer anchor, an example of it, it’s the messy file
of tasiRNAs from [Small RNAs
Carrington](ftp://ftp.arabidopsis.org/Genes/SmallRNAsCarrington/Carrington_MIRNA_TAS_data.xls)
:

``` bash
grep  -n -B 1 -A 20  atTAS3a  AWK/tasiRNA_generating_loci.txt
```

    ## 185-TAS ID:      10
    ## 186:Discription: atTAS3a(At3g17185)
    ## 187-Coordinate:  Chr3:5861491..5862437
    ## 188-Transcript:  atcccaccgtttcttaagactctctctctttctgttttctatttctctctctctcaaatg
    ## 189-                 aaagagagagaagagctcccatggatgaaattagcgagaccgaagtttctccaaggtgat
    ## 190-                 atgtctatctgtatatgtgatacgaagagttagggttttgtcatttcgaagtcaattttt
    ## 191-                 gtttgtttgtcaataatgatatctgaatgatgaagaacacgtaactaagatatgttactg
    ## 192-                 aactatataatacatatgtgtgtttttctgtatctatttctatatatatgtagatgtagt
    ## 193-                 gtaagtctgttatatagacattattcatgtgtacatgcattataccaacataaatttgta
    ## 194-                 tcaatactacttttgatttacgatgatggatgttcttagatatcttcatacgtttgtttc
    ## 195-                 cacatgtatttacaactacatatatatttggaatcacatatatacttgattattatagtt
    ## 196-                 gtaaagagtaacaagttcttttttcaggcattaaggaaaacataacctccgtgatgcata
    ## 197-                 gagattattggatccgctgtgctgagacattgagtttttcttcggcattccagtttcaat
    ## 198-                 gataaagcggtgttatcctatctgagcttttagtcggattttttcttttcaattattgtg
    ## 199-                 ttttatctagatgatgcatttcattattctctttt[tcttgaccttgtaaggccttttct
    ## 200-                 tgaccttgtaagaccccatctctttctaaacgttttattattttctcgttttacagattc
    ## 201-                 tattctatctcttctcaatatagaatagatatctatctctacctctaattcgttcgagtc
    ## 202-                 attttctcctaccttgtctatccc]tcctgagctaatctccacatatatcttttgtttgt
    ## 203-                 tattgatgtatggttgacataaattcaataaagaagttgacgtttttct
    ## 204-TAS region:  696..863
    ## 205-m/siR TAR1:  CTTGTCTATCCCTCCTGAGCTA
    ## 206-m/siR TAR2:  ggtgttatcctatctgagctt
    ## --
    ## 3525-TAS ID:         68
    ## 3526:Discription:    atTAS3a(At3g17185)
    ## 3527-Coordinate:     Chr3:5861491..5862437
    ## 3528-Transcript:     atcccaccgtttcttaagactctctctctttctgttttctatttctctctctctcaaatg
    ## 3529-                aaagagagagaagagctcccatggatgaaattagcgagaccgaagtttctccaaggtgat
    ## 3530-                atgtctatctgtatatgtgatacgaagagttagggttttgtcatttcgaagtcaattttt
    ## 3531-                gtttgtttgtcaataatgatatctgaatgatgaagaacacgtaactaagatatgttactg
    ## 3532-                aactatataatacatatgtgtgtttttctgtatctatttctatatatatgtagatgtagt
    ## 3533-                gtaagtctgttatatagacattattcatgtgtacatgcattataccaacataaatttgta
    ## 3534-                tcaatactacttttgatttacgatgatggatgttcttagatatcttcatacgtttgtttc
    ## 3535-                cacatgtatttacaactacatatatatttggaatcacatatatacttgattattatagtt
    ## 3536-                gtaaagagtaacaagttcttttttcaggcattaaggaaaacataacctccgtgatgcata
    ## 3537-                gagattattggatccgctgtgctgagacattgagtttttcttcggcattccagtttcaat
    ## 3538-                gataaagcggtgttatcctatctgagcttttagtcggattttttcttttcaattattgtg
    ## 3539-                ttttatctagatgatgcatttcattattctctttttcttgacc[ttgtaaggccttttct
    ## 3540-                tgaccttgtaagaccccatctctttctaaacgttttattattttctcgttttacagattc
    ## 3541-                tattctatctcttctcaatatagaatagatatctatctctacctctaatt]cgttcgagt
    ## 3542-                cattttctcctaccttgtctatccctcctgagctaatctccacatatatcttttgtttgt
    ## 3543-                tattgatgtatggttgacataaattcaataaagaagttgacgtttttct
    ## 3544-TAS region:     704..829
    ## 3545-m/siR TAR:      tacctctaattcgttcgagtc
    ## 3546-TAR Method:     Degradome analysis

As the sequence length change depending on each loci, an approach to
extract each row of interest using awk is:

``` bash
awk '/^Discription:/{d=$2};/^Coordinate/{c=$2};/^TAS region:/{s=$3}/^TAR/ {print d,c,s}'  AWK/tasiRNA_generating_loci.txt | grep atTAS3a
```

``` bash
bash AWK/reformatting.sh  AWK/tasiRNA_generating_loci.txt | grep atTAS3a
```

    ## Chr3 5861491 5862437 atTAS3a(At3g17185)  696 863 Chr3:5861491..5862437
    ## Chr3 5861491 5862437 atTAS3a(At3g17185)  704 829 Chr3:5861491..5862437

### If loops

#### Conditional evaluation

Using the same previous example, this time without modifiend the header
of the SRA original file, but using if structure to indicate
differential processing of first line vs the complementary text:

``` bash
awk -F',' -v OFS="," '{if (NR == "1") {$10=$11=$12=""; print  } else {gsub("ncRNA-Seq","smallRNA-Seq",$2);print  }}'
```

``` bash
bash AWK/separator.awk AWK/SraRunTable.txt "IF"
```

    ## Run,LibraryLayout,Assay_Type,Organism,ecotype_background,source_name,Plant_age,days_past_infection,Genotype,AvgSpotLen,Bases,treatment
    ## SRR17697100,PAIRED,smallRNA-Seq,Arabidopsis_thaliana,Col-0,rosette,39_days,21,dcp5-1/rdr6-15,102,4009784628,CaMV_(CM184I)_infected

This code has an additional unneeded feature, the deletion of three
fields, but it works to illustrate differential processing depending of
an If condition.

#### IF in arrays as a classificator:

One of my favorite codes made a classificatory tasks extremely fast and
with just a handful set of commands, sadly the economy of the codes
makes it a little dark, especially for AWK beginners.

<details>
<summary>
Let’s see a toy example:
</summary>

``` bash
#We can create a toy data (td) set  with a chromosome location of a given gene

#Chromosome  #Duplicated Gene
#chr1       geneA
#chr2       geneB
#chr3       geneA

echo -ne "Chromosome\tDuplicated Gene\nchr1\tgeneA\nchr2\tgeneB\nchr3\tgeneA\n" > AWK/td_Gene_duplication_per.txt 
```

</details>
Sadly, although it seems awk engine is implemented for R markdown, it
requires an additional effort to make it work, here the code of how to
run awk using
[knitr](https://github.com/yihui/knitr-examples/blob/master/024-engine-awk.Rmd),
and here the [R markdown
output](https://github.com/yihui/knitr-examples/blob/master/024-engine-awk.md)
of that code, however after several attempts I could not make awk work
here, anyway, awk is integrated as a command on bash, then we can write
the comand of awk as a awk script and executing with bash.
<details>
<summary>
The code is
</summary>

``` bash
head -n 25 AWK/classificator.awk 
```

    ## #!/bin/bash
    ## # Welcome my github readers, this an awk script commented, in reality this code can
    ## # be excecuted as a one liner, even including saving the process on a new file, but R markdown 
    ## # does not handle all of the awk power, by now
    ## #
    ## # The  One-liner format
    ## #
    ## # awk 'NR>1{if(a[$2])a[$2]=a[$2]" and "$1; else a[$2]=$1;}END{for (i in a) print "The gene "i", is located on chromosome "a[i];}' 
    ## #
    ## # But I will explained as a script here
    ## #     awk 'NR>1{
    ##  # Omit the first line   
    ## #     if(a[$2]) a[$2]=a[$2]" and "$1
    ##  # make an array with the second field (column by default splitted by tab)
    ##  # and if the element is already on the array, add extra attributes (first column) as a coment separated with ` and `
    ## #     else a[$2]=$1} END  {for (i in a)
    ## # if the element is not on the array, save it as a new element with its related attribute
    ## #     print "The gene "i", is located on chromosome "a[i] }' $1
    ##   # Finally a for loop for print array elements with a presenting words
    ##   # Without commetns clean like this: 
    ## awk 'NR>1{ if(a[$2]) a[$2]=a[$2]" and "$1; else a[$2]=$1} END  {for (i in a)  print "The gene "i", is located on chromosome "a[i]}' $1

</details>
<details>
<summary>
The output of this script
</summary>

``` bash
bash AWK/classificator.awk AWK/td_Gene_duplication_per.txt
```

    ## The gene geneA, is located on chromosome chr1 and chr3
    ## The gene geneB, is located on chromosome chr2

</details>
<details>
<summary>
What happen if we include more genes ?
</summary>

``` bash
echo -ne "chr4\tgeneA" >> AWK/td_Gene_duplication_per.txt 

bash AWK/classificator.awk AWK/td_Gene_duplication_per.txt
```

    ## The gene geneA, is located on chromosome chr1 and chr3 and chr4
    ## The gene geneB, is located on chromosome chr2

</details>

Now let’s see this code applied to real world problems, at least how I
used, one example is here PRINT here how it work to make quick table
(Mirnomics project) or for multi-fasta file duplication cleaning
(gRNAs_total.fa)

DEVELOP HERE

------------------------------------------------------------------------

-   IF and arrays as de-duplicated control structures:

Sum a particular column

``` bash
awk '{sum+=$7} END {print sum}'  
```

sum non duplicated rows as an example of the UNDEVELOPED code here

DEVELOP HERE

#### For and While

Sum all columns

``` bash
awk 'BEGIN{FS=OFS=","}
     NR==1{print}
     NR>1{for (i=1;i<=NF;i++) a[i]+=$i}
     END{for (i=1;i<=NF;i++) printf a[i] OFS; printf "\n"}' file
```

<!-- POSSIBLE awk commands forgotten 
/mnt/g/My\ Drive/Bioinformatica/0_Tesis\ Maestria/Code/Analysis_miR/Create_and_filter_anotation_file.txt 

/mnt/g/My\ Drive/Bioinformatica/0_Tesis\ 
./Code/Blockbuster_parsearch/Clust2Block/No_blocks_loci/blockbuster_test.txt

./EGlab_Code/Trimmomatic/trimmomatic_behaviour.txt

/mnt/g/My\ Drive/Bioinformatica/0_Tesis\ Maestria/Precise_counting/Readme.txt
-->

------------------------------------------------------------------------

-   While, beigin honest I have never used while loop on awks. But I do
    use while structure on bash followed by an awk code, which is, awk
    as line per line variable mining tool, which employ the next code
    structure:

``` bash
echo  "This a toy example; with a semicolon separator structure; and I want to show you; hidden variable X 
that using bash while loop; and awk -F separator command; I can extract pf each line the; hidden variable Y" > toy_structure.txt

head toy_structure.txt
```

    ## This a toy example; with a semicolon separator structure; and I want to show you; hidden variable X 
    ## that using bash while loop; and awk -F separator command; I can extract pf each line the; hidden variable Y

``` bash
counter=1   ### Bash counter - reference here for access from other sites
while read line 
do 
variable=`echo $line | awk -F'; hidden variable' '{print $2}'`
echo this is the value of the hidden variable: "$variable" on the line: "$counter" 
let counter=counter+1 
done < toy_structure.txt 

rm -f toy_structure.txt
```

    ## this is the value of the hidden variable:  X on the line: 1
    ## this is the value of the hidden variable:  Y on the line: 2

A real world problem where I use awk inside a bash while loop structure
is in a fastqc quality information miner script, extracted from
[NGS_statistics.sh script](Total_processing/NGS_statistics.sh):
<details>
<summary>
Non excecutable script
</summary>

     while read library
     do
     FILE="$1"/Fastq/Quality/$library/fastqc_data.txt
     
     type_file=`echo $library | egrep -o  "_fastqc|_reduced_cor_fastqc|.reduced_fastqc|_trim_fastqc"`
     
     name=`echo $library | awk -v sus="$type_file"  '{gsub(sus,"",$0);print $0}'`

     if [ "$type_file" == "_fastqc" ]
     then
     lib_type="raw"
     elif [ "$type_file" == "_reduced_cor_fastqc" ]
     then
     lib_type="ms_reduced"
     elif [ "$type_file" == ".reduced_fastqc" ]
     then
     lib_type="reduced"
     elif [ "$type_file" == "_trim_fastqc" ]
     then
     lib_type="tmm_reduced"
     fi

     awk '/^Total Sequences/{ts=$3}  /^Sequence length/{print "'$name'" "\t" "'$lib_type'" "\t" $3 "\t" ts}' $FILE   >> $1"Results/Statistics/Total_size.txt"

     done < dir_list.txt

</details>

------------------------------------------------------------------------

-   For loops on awk are mainly array handlers:

DEVELOP HERE

------------------------------------------------------------------------

## Bash

Here as well as with awk there are many commands that using cleverly you
can get results with a single one-liner, or post process, clean, adjust
ins/outs quickly or to change formats to give to more complicated
programs. Bash it’s for me, as you saw previously, the main executor,
for other people it could be shell, or even anything without command
line, by running all in environments like this, but with VIM + Bash +
awk + perl virtually you could do everything on structured programming.
But before to get into the details of how I used recurrent blocks of
code, I will introduce a unique aspect of bash:

### Generalities of my bash codes

Bash as well as AWK is quite flexible, however most of the time I do use
the three control structures `for`, `while` and `if, then, else` for
data organization, classification or text processing and quality
control. But before to enter to each control structure let’s talk some
other features of Bash beyond the control statements itself.

#### Piping on bash: beyond “\|”

Bash is awesome specially when we talk about pipes, input and output
immediately re-direction. However for beginners the main command for
piping is usually “\|”, which limits piping to comands who tolerate
input redirection in such way, however there are software which cannot
be piped with “\|” but it might accept “-” for input file declaration,
specially those who requires a -i parameter to indicate the input file,
then the piping way for such programs is ” \| software -i - ” .

DEVELOP HERE - example of - for piping

A less usual piping commands is the combined operator “\<( code here )”,
which could be interpreted as “take the output of the command between
parenthesis as an input”. This structure could be used to expand the
capabilities to of grep command but in the option of grepping a list of
terms (grep -f). Using the -f parameter on a grep search we cannot add
the single pattern options available also as parameter, for instance,
searching the list of pattern at the beginning of each line:
`grep -f "^"`, however using `<()` this task it’s possible. Let’s
explore using a real world problem.

In a file of small RNAs who target genes for mRNA edition process (U
deletion or insertion), each line represent a guide RNA, whoever some of
them has complex gene target assignation, meaning for instance like:

“Unknown_RPS12”

Where the first category means the guideRNA have gotten a gene target
after a secondary process, but a gene without a gene target even after
applying the secondary process, could still lack of a gene assignation.
Additional patterns like RPS12_Unknown_RPS12, make even harder the use
of auxiliary awk syntax. Therefore, to quantify the exact amount of
gRNAs with pure Unknown gene targets we can use the `<()` syntax as
follow:

First generate the pattern to search using the single line grep regular
expressions as “^” or “$” or others, for instance starting with a file
like this:

``` bash
head -n 1 BASH/grep_lists_example.txt
```

    ## 2481_319857-5

Where each line represent a single ID, now as this pattern in the file
we want to search it might be place on more than one column, a exact
grep (-w) search would not be enough, the file to search looks like:

``` bash
head -n 1 BASH/file2search.txt
```

    ## 2481,319857-5:3775637-1:612463-2:1522040-1:1644068-1:728577-2:1155110-1:2471552-1:3702130-1:2610329-1:2598439-1:3570331-1:1741739-1:3268900-1:3271495-1:1374495-1:1145964-1,94,94,AAATATAACATATCTTATATCTGAATCTAACTTGTAATATGTGAATTTTTTTTTTTTTTTT,AAATATAACATATCTTATATCTGAATCTAACTTGTAATATGTGAA,RPS12_A1,1306,68762-

The pattern we are interested is the first field of this comma separated
file, as it’s numerical it might happen in many places, then what we
need to search is a list of ids who start exactly with that number and
ends with a comma, we can create a list of IDs with these features:

``` bash
bash AWK/printBeginningEnd.awk BASH/grep_lists_example.txt  > BASH/tempids.sh

head -n 1 BASH/tempids.sh
```

    ## echo -ne "^2481,\n^68762,\n^28853,\n^54107,\n^68071,\n^68171,\n^115266,\n^24851,\n^37211,\n^102948,\n"

With awk basically we have created a script who writes another script,
which tells to bash how to print the code, if we excecute this code it
will look as follow:

``` bash
bash BASH/tempids.sh | head -n 2
```

    ## ^2481,
    ## ^68762,

Now with this script we can run the line `bash tempids.sh` inside `<()`
command as an input for the command `grep -f`:

``` bash
time (bash BASH/piping.sh BASH/file2search.txt)
head BASH/piping.sh
```

    ##       7 RPS12_A1
    ##       3 RPS12_A2
    ## 
    ## real 0m0,002s
    ## user 0m0,004s
    ## sys  0m0,000s
    ## grep -f <(bash  BASH/tempids.sh) $1 | awk -F',' '{print $7}'  | sort | uniq -c

In such way this code is equivalent to run grep in a for loop as:

``` bash
bash BASH/piping_alternative.sh BASH/file2search.txt
head BASH/piping_alternative.sh
```

    ##       7 RPS12_A1
    ##       3 RPS12_A2
    ## 
    ## real 0m0,006s
    ## user 0m0,007s
    ## sys  0m0,001s
    ## tempids=()
    ## tempids=$(cut -d '_' -f 1  BASH/grep_lists_example.txt)
    ## time ( for f in ${tempids[@]}; do grep "^"$f","  $1; done | cut -d ',' -f 7  | sort | uniq -c )

Even faster than an awk search:

``` bash
bash BASH/awk_regrex_insideFor.sh BASH/file2search.txt 
tail -n 1  BASH/awk_regrex_insideFor.sh
```

    ##       7 RPS12_A1
    ##       3 RPS12_A2
    ## 
    ## real 0m0,007s
    ## user 0m0,007s
    ## sys  0m0,001s
    ## time ( for f in ${tempids[@]};  do  awk -F',' '/^'$f',/{print $7}' $1 ; done | sort | uniq -c  ) # $1 ~ /^'$f'$/ equivalent

However the first code is much faster as time command show us, the
reason of this is because the first is in reality a single grep search
without control structures.

The second code has the bash array structure and the way it can be feed
it, also as an alternative to avoid temporary files. Also includes how
we can access or called in a bash for loop, [more of bash arrays
here](https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays).

#### Folder syncronization with rsync

Specially useful command for servers with file deletion programs, this
command will ensure you data security:

``` bash
rsync -av /mnt/ls15/scratch/users/gutie190/MaxiCircles/ /mnt/home/gutie190/Trypanosomes_RNA_editing/MaxiCircles/NewMaxiCircles/
```

This command will copy all files from the scratch directory to the safe
local directory, where there is not deletion policty, but disk space
limitations.
[Source](https://www.tutorialspoint.com/unix_commands/rsync.htm)

`-a` means The files are transferred in “archive” mode, which ensures
that symbolic links, devices, attributes, permissions, ownerships, etc.
are preserved in the transfer.

Each time the mother folder is modified, you should run again the
command, rsync remote-update protocol will update the file by sending
only those different to the already synchronized files.

By default `rsync` only add files to the destination folder that have
been added to the source folder, adding or modifying files that have
been changed in the source folder but does NOT delete any files if they
have been deleted in the source. To delete files in the target, add the
–delete option to your command.

``` bash
rsync -avh source/ dest/ --delete
```

Sometimes previous to rsync it’s important to delete empty folders,
which may be done with find:

``` bash
find . -type d -empty -delete
```

#### Grep with perl regrex

Grep command is one of the most famous search software known, it’s so
powerful thank it’s possible to use together with other languague as
perl, for instance, in a complex data set as the following:

``` bash
head -n 8 BASH/complex_formatting.txt
```

    ## 1. The Arabidopsis F-box protein FBW2 degrades AGO1 to avoid spurious loading of illegitimate small RNA [PARE-seq]
    ## (Submitter supplied) RNA silencing is a conserved mechanism in eukaryotes and is involved in development, heterochromatin maintenance and defense against viruses. In plants, ARGONAUTE1 (AGO1) protein plays a central role in both microRNA (miRNA) and small interfering RNA (siRNA)-directed silencing and its expression is regulated at multiple levels. Here we report that the F-box protein FBW2 targets proteolysis of AGO1 by a CDC48-mediated autophagy mechanism. more...
    ## Organism:       Arabidopsis thaliana
    ## Type:           Non-coding RNA profiling by high throughput sequencing; Other
    ## Platform: GPL17639 18 Samples
    ## FTP download: GEO (TXT) ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE169nnn/GSE169433/
    ## SRA Run Selector: https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA716605
    ## Series          Accession: GSE169433    ID: 200169433

For each entry there are 7 lines of information, to extract an specific
query, non separated information, with only alphanumeric characters
match, including connector characters as “\_” or, we can use grep -oP
command and perl
[“\\w+”](https://stackoverflow.com/questions/47361430/about-the-meaning-of-perl-w)
expression to include the whole word, as follow :

``` bash
grep -oP "Accession: \w+"  BASH/complex_formatting.txt
```

    ## Accession: GSE169433
    ## Accession: GSE169324

The information include in perl matching characters as + can be
displayed using:

``` bash
unichars -a -u '\w' | wc -l 
```

To check the difference in perl matching characters, we can use unichars
and diff command, however they are not available in all unix systems

``` bash
diff -u  <( unichars -a -u '\w' )  <( unichars -a -u '\d' )
```

#### Use defined match delimiters

A more intuitive, versatile and controllable way for the same task is
the perl “?” and “(?=)” regrex pairs, which allow us to define the
limits of character exploration. Let’s use an aburd example, such as
matching any characters before a defined word (“abc”) is found, without
including the define word as an output.

``` bash
 echo addfadfaabc1234 | grep -oP "(.+?)(?=abc)"
 #One liner perl version of this is
 # perl -ne ' $_ =~ s/(.+?)(?=abc)/$1/; print $1;' 
```

    ## addfadfa

Using the previous complex formatting text:

``` bash
cat BASH/complex_formatting.txt | grep -oP "Type:(.+?)(?=[\n|;])"  
```

    ## Type:           Non-coding RNA profiling by high throughput sequencing

An equivalent expression to “\\w+” examples

``` bash
grep -oP "(Accession:.+?)(?=ID)"  BASH/complex_formatting.txt
```

#### Find and bash commands

Find command is one of the most useful tools in unix systems, it’s the
google inside this beautiful operative system, not only because it does
allow us to find any file or folder using regrex, but also because it’s
able to search inside the files, including pdfs files (in case pdfgrep
is installed).

1.  The basics, search for all the files with common extension and list
    their sizes and time of origin

``` bash
find . -name '*.sh'  -exec ls -lht  {} \; 
```

keep in mind just “\*” is enough for global search, “.” in find it’s a
non-special character

What if you want to copy those files to a new folder?

``` bash
find  BlastNT/ -iname "*sb" -print -exec  cp {}  ~/GS21/BLAST_DB/ \;
```

1.  Grep inside a file providing the name of the file

``` bash
find . -name '*.txt' -exec grep -H "perl \-ne"  {} \;
```

### Bask parallelizing 101:

#### Measuring excecution time

[check execution time of process whose id is
known](https://www.2daygeek.com/how-to-check-how-long-a-process-has-been-running-in-linux/)

``` bash
ps -p 16337 -o etime
```

#### Forks and CPUs work distribution

#### Parallel

### Soft and Hard links (ln)

A hard link acts as a copy (mirrored) of the selected file, while soft
or symbolic links acts as a pointer or a reference to the file name,
however keep in mind, deleting a pointer is also deleting the original
folder. A situation taht does not happen with hard links.

### Creating comands on Bash

-   Save routinary functions and alias as bash commands with the label
    you want to use it for them on the terminal. To start, what we need
    it’s edit the file `~/.bashrc` with your favorite text editor, in my
    case Vim ([(guide for vim commands)](VIM/README.md)). The difference
    between alias and the functions is mainly that the functions read
    arguments, while alias not. My favorite list of alias and functions
    on .bashrc file

<details>
<summary>

-   Alias
    </summary>

``` bash
# List the files in human readble format withut writing -lh and
# organize them by size, from bigger to smaller
alias lso='ls -lh  --sort=size'

# List the files in human readble format withut writing -lh and 
# organize them by time of modification, from sooner to later 
alias lst='ls -lh  --sort=time'

# Delete the files but asking first if that's what you really want 
alias rm='rm -i'
# anyway rm -f would delete without asking, but it requires from you an extra
# time thinking 

# I usually work on servers, I do not like to write ssh hostname@server thousands of time
alias msuhpc=' ssh -X USER@SERVER'

# First time on the matrix? sometimes is hard to know if you are working on a screen session 

alias iscreen=' echo $TERM ' 

# If you are on a server always work on screens, if you lose connection, the screens nope, 
# but outside the matrix, the world is harder. 

# Again an useful alias when you do not want to be kick out from the server, but you are not
# mentally there 

alias waste_time='for f in {1..200}; do echo ------ wasting time minutes $f;  sleep 60; done'
```

</details>
<details>
<summary>

-   Functions
    </summary>

Alias are boring, but save time. Functions are quite interesting, they
are basically mini software and bash allow you to create commnads as
variated as a blast of a sequence you want to test against blast
databases.

``` bash
# LiSt the Absolut path Directory of a file 
lsad() {
find $PWD -iname $1
}

# List the size of a folder
lsf(){
du -ch --max-depth=0  $1
}

# Search on history a past command 
hisgrep() {
history | grep $1
}

# What if you use a file many times and the previous command shows many boring history
# You can also check only when the file you are interested in was generated 
hisgrep_gen() {
hisgrep "-P \>\\s+$1"
}

# That's all for today darling screen 
delete_screen() {
screen -X -S $1 quit
}


# Adjust the title of a paper to my format of saving it 
papers() {
        final=`echo "$1" | tr '\n' '_' | tr -d '–' |tr ' ' '_' | tr -d ',' |tr -d ':' | tr -d '(' | tr -d ')' | tr '/' '-' | awk -F '_$' '{gsub("__","_",$1);print $1}' | awk -F '_$' '{print $1}' `
echo $2.$final
}

# How many nucleotides do a sequence has
count_nt() {
seq=`echo -ne $1 | wc -c`
echo $seq nucleotides
}

# Get the reverse complementary sequence of a 
revcom() {
 if [ "$1" == "DNA" ]
 then
 echo $2 | rev | tr 'ACGTacgt' 'TGCAtgca'
 elif [ "$1" == "RNA" ]
 then
 echo $2 | rev | tr 'ACGUacgu' 'UGCAugca'
 fi
 }

# Check how large is the load of a server
server_status() {
ssh server free -h
ssh server  ps aux --sort=-pcpu | egrep -v "root" | head # add any annoying software always coming up from ps 
ssh server  ps aux --sort=-pcpu   | awk 'NR>1{sum+=$3;sum2+=$4}END{print "Cores used "sum "% and RAM used "sum2" %"}'
}

# Search in a given directory a file by its pattern
reference(){
pattern=`echo $1`
find $2 -iname "*$pattern*"  -print 2>/dev/null 
}

# Search a word in a pdf o thousands of pdfs on a common directory or a single file
# Of course it does requires the installation of pdfgrep
intext(){
find "$1" -name '*pdf' -exec pdfgrep -i "$2" /dev/null {} \; 2>/dev/null
}
```

</details>

These newly defined codes can be used even into common scripts, but
first it requires installation:

``` bash
source ~/.bashrc
```

To running here, I need to use these commands into scripts, and then you
must use the `-i` parameter, which means:

`-i        If the -i option is present, the shell is interactive.`

Let’s see an example, tell me computer how looks the reverse
complementary sequence of ACCCCGAGACTAGGTAGAGACA and how many
nucleotides are there?:

This is how looks the script for this:

``` bash
head BASH/running_bashrc.sh
```

    ## 
    ## revcom DNA ACCCCGAGACTAGGTAGAGACA
    ## 
    ## count_nt ACCCCGAGACTAGGTAGAGACA

… And here the output:

``` bash
bash BASH/running_bashrc.sh
```

------------------------------------------------------------------------

## Perl

Perl engulf awk in its language evolutionary history,

### Oneliners or -ne command

In previous sections I’ve already shown how versatile is perl’s regrex,
using them with grep or the ones shared between perl and awk, however if
we want to manipulate a file and not only detect, the most precise way
before running into formatting-scripts is the use of perl oneliners. The
next example shows a perl one-liner script with a economic writing or
non-strict style, starting with:

1.  `chomp $_`, dispensable but used to remove the last trailing newline
    from the input string.
2.  `@F = split /\t/` , feed the environment array F with each part of
    the text separated by tab or any other character.
3.  `if ($N[1] ne "hsaP-") {$F[3] =~ s/(hsaP)[a-z].*-([let|mir].*)/$1-$2/;`
    control structure, restricting the substitution to only those
    entries with different name to “hsaP-”
4.  `$string=join ("\t", @F); print "$string\n";}`, re join split and
    modified fields and close control structure.

<!--, -->

``` bash
echo -ne "chr1\t115215\t115320\ttesting-syntax_hsaPmmu-mir-23a\nchr1\t115215\t115320\ttesting-syntax_hsaP-let-23a\n-Previous to perl edition-\n" 
tail -n 1 Perl/oneliner_search-replace.sh
```

    ## chr1 115215  115320  testing-syntax_hsaPmmu-mir-23a
    ## chr1 115215  115320  testing-syntax_hsaP-let-23a
    ## -Previous to perl edition-
    ## perl -ne 'chomp($_); @F = split /\t/, $_; @N = split /_/, $F[3]; if ($N[1] ne "hsaP-") {$F[3] =~ s/(hsaP)[a-z].*-([let|mir].*)/$1-$2/; $string=join ("\t", @F); print "$string\n";}'

``` bash
bash Perl/oneliner_search-replace.sh 
```

    ## chr1 115215  115320  testing-syntax_hsaP-mir-23a
    ## chr1 115215  115320  testing-syntax_hsaP-let-23a

<!-- Usar perl en R markdown, se puede https://stackoverflow.com/questions/45857934/executing-perl-6-code-in-rmarkdown 
--->

## GitHub

### Reconnecting from a new repository

[Pushing to github with
ssh-authentication](https://www.r-bloggers.com/2014/05/rstudio-pushing-to-github-with-ssh-authentication/)

The current project was syncronized by this method using the command

``` bash
git config remote.origin.url git@github.com:AimerGDiaz/Codes_Repository
```

## License

My codes are licensed under a [Creative Commons Attribution-ShareAlike
4.0 International
License](https://creativecommons.org/licenses/by-nc/4.0/).

[![License: CC BY-NC
4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)

## Viewers

[![Image of
Viewers](https://github.com/AimerGDiaz/Viewers/blob/master/svg/409164432/badge.svg)](https://github.com/AimerGDiaz/Viewers/blob/master/readme/409164432/week.md)
