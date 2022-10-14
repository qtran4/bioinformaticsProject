#Compiles all the individual hsp70 and mcrA sequences into one file 
cat ref_sequences/hsp70*.fasta > hsp70seq.fasta
cat ref_sequences/mcrA*.fasta > mcrAseq.fasta

#Uses combined seq files to form alignments using muscle
~/Private/Biocomputing2022/Tools/muscle -in hsp70seq.fasta -out hsp70align.afa
~/Private/Biocomputing2022/Tools/muscle -in mcrAseq.fasta -out mcrAalign.afa

#Uses alignments to build a profile with hmmbuild 
~/Private/Biocomputing2022/Tools/hmmbuild hsp70profile.hmm hsp70align.afa
~/Private/Biocomputing2022/Tools/hmmbuild mcrAprofile.hmm mcrAalign.afa

#Sets headings for summary file and creates or overwrites summary csv file
echo proteome, hsp70_matches, mcrA_matches > summary.csv

#loops through all proteomes in proteomes file
for file in proteomes/*
do

#Represents the name of the current proteosome and modifies formatting 
a=$(echo $file | sed 's/.fasta//' | sed -e 's/proteomes.//')

#Searches the hsp70 profile in current proteome and gets match number
b=$(~/Private/Biocomputing2022/Tools/hmmsearch hsp70profile.hmm $file | grep 'Domain search space' | cut -d ' ' -f 20) 

#Searches for mcrA profile in current proteome and gets match number
c=$(~/Private/Biocomputing2022/Tools/hmmsearch mcrAprofile.hmm $file | grep 'Domain search space' | cut -d ' ' -f 20)

#Appends proteome name and hsp70 and mcrA matches to summary file
echo $a, $b, $c >> summary.csv
done 

#Removes heading of summary file as well as proteomes with no matches 
#Sorts by number of hsp70 matches (highest to lowest), gets top four matches (each with 3 hsp70) and saves proteome names to candidate file
cat summary.csv | sed '1d' | sed -e '/, 0/d'| sort -k2,2nr | head -n 4 | cut -d, -f 1 > candidates.txt


