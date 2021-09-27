Codes repository and Oneliners explained
================
Aimer G. Diaz

<!---
https://github.com/gayanvoice/github-profile-views-counter
Sintaxis propia de github markdown https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
Sintaxis for all the R markdowns in general https://bookdown.org/yihui/rmarkdown-cookbook/raw-latex.html 
El tema de las licencias https://gist.github.com/lukas-h/2a5d00690736b4c3a7ba
Cuando lanze los pauetes tanto de deteccion de fragmentos como el script de reduccion de librerias https://docs.github.com/en/enterprise-server@2.22/packages/quickstart  

--->

Welcome to my code repository, most or all of it I’ve learned in a very
inclusive sense of the word (including copy from internet forums),
following this beautiful logic of public domain I’ve made these notes
available, the idea it’s to have a server-independent repository, a
repository on the cloud, or should I say, on the bottom of the ocean
with several copies in several sites of the world, for today and maybe,
just maybe, even available on a post-global ecological disaster era,
available physically but not online 😮.

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

| SRA\_Code  | Sequence\_Tech | Cell\_location\_stage       | Strain     | Total\_Sequences | Length  | Source           | ServerName                 |
|------------|----------------|-----------------------------|------------|------------------|---------|------------------|----------------------------|
| SRR8859642 | PAIR END       | Procyclic                   | EATRO 1125 | 85,827,714       | 125/125 | Cooper2019\_gRNA | Cooper2019\_gRNA\_E1125PC  |
| SRR8859640 | PAIR END       | Bloodstream                 | EATRO 1125 | 79,132,567       | 125/125 | Cooper2019\_gRNA | Cooper2019\_gRNA\_E1125BS  |
| SRR8859641 | PAIR END       | Bloodstream + Procyclic MIX | EATRO 1125 | 148935513        | 125/125 | Cooper2019\_gRNA | Cooper2019\_gRNA\_E1125Mix |

The first version of the file is [on the master thesis codes
folder](Total_processing/Download_script.sh), however this version did
not has the option to download the SRA considering if it’s single or
paired end. The latest version of it does and it’s on the [Trypanosoma
repository](https://github.com/AimerGDiaz/Trypanosomes_RNA_editing).

## Codes repository

In order to start, I will comment here sections of the codes and the way
I apply them to solve specific problems, in other terms, here what you
will find is a selection of commented and finished codes in bash, awk,
perl, python, R and Latex languages, plus R markdowns files explaining
these codes using small toy data sets. Finally in this document you can
also find useful one liners commented, also with toy examples.

Let’s starti with the one-liners, it’s true they are not the best
solution, however they are fast, they avoid us to write or re-adapt
whole blocks of code to particular solutions, they are modular and
somehow, they are like culture, beyond if it’s recommended or not to use
them, some people love them and I am one of those. I will introduce them
first, because I always started with them to explore the original data,
already made analysis, new formats, supplementary material, etc.

## Awk one-liners

Awk codes are my favorite, the one liners are extreamlly useful, fast,
weird but incredible, but they can be adapted as bash codes and even
using in parallel computing by the amazing GNU parallel software with
minor modifications as I will show here. But let’s start, the selected
awk codes and toy data samples will be [here](AWK/README.md).

### Generalities of my awk codes

One of my favorite codes made a classificatory tasks extremely fast and
with just a handful set of commands, sadly it makes also the code pretty
dark for the first times, let’s see a toy example:

``` bash
#We can create a toy data (td) set showing the same row each time a gene on different chromosomes 

#Chromosome  #Duplicated Gene
#chr1       geneA
#chr2       geneB
#chr3       geneA

echo -ne "Chromosome\tDuplicated Gene\nchr1\tgeneA\nchr2\tgeneB\nchr3\tgeneA\n" > AWK/td_Gene_duplication_per.txt 
```

Sadly, although it seems awk engine is implemented for R markdown, it
requires an additional effort to make it work, here the code of how to
run awk using
[knitr](https://github.com/yihui/knitr-examples/blob/master/024-engine-awk.Rmd),
and here the [R markdown
output](https://github.com/yihui/knitr-examples/blob/master/024-engine-awk.md),
however after several attempts I could not make awk work here, anyway,
awk is integrated as a command on bash, then we can write the comand of
awk as a awk script and excecuting with bash: the code is

``` bash
head -n 20 AWK/classificator.awk 
```

    ## # Welcome my github readers, this an awk script commented, in reality this code can
    ## # be excecuted as a one liner, even including the print of the file, but R markdown 
    ## # does not handle all of the awk power, by now
    ## #
    ## # The  One-liner format
    ## #
    ## # awk 'NR>1{if(a[$2])a[$2]=a[$2]" and "$1; else a[$2]=$1;}END{for (i in a) print "The gene "i", is located on chromosome "a[i];}' 
    ## #
    ## # But I will explained as a script here
    ##   awk 'NR>1{       
    ##   if(a[$2]) a[$2]=a[$2]" and "$1
    ##   else a[$2]=$1} END  {for (i in a) 
    ##   print "The gene "i", is located on chromosome "a[i]}' $1

Script execution

``` bash
 
bash AWK/classificator.awk AWK/td_Gene_duplication_per.txt
```

    ## The gene geneA, is located on chromosome chr1 and chr3
    ## The gene geneB, is located on chromosome chr2

What if we include more genes ?

``` bash
echo -ne "chr4\tgeneA" >> AWK/td_Gene_duplication_per.txt 

echo "Lest running again" 

bash AWK/classificator.awk AWK/td_Gene_duplication_per.txt
```

    ## Lest running again
    ## The gene geneA, is located on chromosome chr1 and chr3 and chr4
    ## The gene geneB, is located on chromosome chr2

-   Save routinary codes as bash commands with my own label to called
    them on the terminal. To start what we need it’s do edit the file
    `~/.bashrc` with favorite text editor [(guide for vim
    commands)](VIM/README.md)

Functions

    lsad() {
    find $PWD -type f -iname $1
    }

## Perl one-liners

<!-- Usar perl en R markdown, se puede https://stackoverflow.com/questions/45857934/executing-perl-6-code-in-rmarkdown 
--->

## License

My codes are licensed under a [Creative Commons Attribution-ShareAlike
4.0 International
License](https://creativecommons.org/licenses/by-nc/4.0/). [![License:
CC BY-NC
4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)
