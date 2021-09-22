# MaizeTSS_CAGE

## Forging BSGenome Maize package 

The present folder has the code necessary to generate BSGenome R package for maize B73 AGPv3, v4 and v5, adiddtionaly for Mo17 Cau v1.0, starting from the fasta sequence, transforming to 2bit format and forging R BSgenome package.  

The BSGenome R packges output of this initial parte are available at [EGlab BSGenome maize repository] (https://drive.google.com/drive/folders/1DimXX0S9Z2oloCKQiRCNk0j-YMMEvI1k?usp=sharing) 

### Notes Package forging 

There are some important general and specific notes for the BSgenome packages forged here: 
 - All the package are built using soft masking genome versions, for B73 AGPv3 and AGPv4 are downloaded versions from [Gramene](http://www.gramene.org/). For AGPv5 and Mo17 the soft masking versions of each genome was produced locally using RepeatMasker v 4.1.0 with the next parameters: 
  `RpeatMasker -pa 8 -gff -xsmall -species maize -norna -s <Genomes.fa>`  
 
 - Mo17 and AGPv5 genomes lacks mitochondrial and plastd genomes in the BSgenome packge forged here, that's why in the BSgenome description you won't find the section:
  `circ_seqs: c("Mt","Pt")`
  - The source of each genome fasta is:
    - AGPv3 :  ftp://ftp.ensemblgenomes.org/pub/plants/release-31/fasta/zea_mays/dna/
    - AGPv4 :  ftp://ftp.ensemblgenomes.org/pub/plants/release-40/fasta/zea_mays/dna/
    - AGPv5 :  https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/
    - Mo17_Cau : ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/185/045/GCA_003185045.1_Zm-Mo17-REFERENCE-CAU-1.0/
 
