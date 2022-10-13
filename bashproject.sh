#This script can align reference proteome files that contain two specific genes within an entire proteome sequence
#This script is a model for alignment and can search for matches
#Matches will determine whether or not the proteomes carry both specific gene sets 

#usage: bash bashproject.sh

#make a hsp70ref file and mcrAref file each containting all the reference sequences
cat ref_sequences/hsp70gene_*.fasta > hsp70ref
cat ref_sequences/mcrAgene_*.fasta > mcrAref

#align all the reference sequences for the two genes
../tools/muscle -in hsp70ref -out hsp70musclealign
../tools/muscle -in mcrAref -out mcrAmusclealign

#generate two HMM profiles for hsp70 and mcrA genes
../tools/hmmbuild --amino hsp70HMMbuild hsp70musclealign
../tools/hmmbuild --amino mcrAHMMbuild mcrAmusclealign

#search each proteome for matches
cd proteomes
for file in *.fasta
do
../../tools/hmmsearch --tblout hsp70_$file ../hsp70HMMbuild $file
../../tools/hmmsearch --tblout mcrA_$file ../mcrAHMMbuild $file
done

#search each result file
#print each proteome name and matches for each gene

echo "proteome_number, hsp70_matches, mcrA_matches" > ../matches.txt

for file in proteome_*.fasta
do
hsp70_match=$(cat hsp70_$file | grep -v '#' | wc -l)
mcrA_match=$(cat mcrA_$file | grep -v '#' | wc -l)
echo "$file, $hsp70_match, $mcrA_match" | sed 's/.fasta//g' >> ../matches.txt
done

cd ..

#when choosing best candidates, we elimated proteomes that did not have matches for either hsp70 or mcrA
#then the rankings of best candidates were determined by sorting the highest matches of hsp70
#we determined that one mcrA was sufficient for a candidate and that more hsp70 matches was a more desirable candidate

echo "Best candidate proteomes listed and sorted by greatest number of matches" > candidate_results.txt
cat matches.txt | grep -v "proteome_number" | grep -v " 0" | sort -k 2nr | cut -d , -f 1 >> candidate_results.txt

