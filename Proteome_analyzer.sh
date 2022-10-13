# This script takes an input of a certain number of proteomes and searches each genome for
# gene sequences of interest, using a Hidden Markov Model created with reference
# sequences of the given gene. The script then creates a summary table collating the results
# of all searches, and finally generates a text file containing its recommendations for
# pH-resistant methanogen candidate proteomes
# Usage: bash Proteome_analyzer.sh mcrA_gene_refsequences_directory hsp70_gene_refsequences_directory proteome_sequences_directory

cat $1/mcrAgene_*.fasta | ~/Private/Biocomputing2022/tools/muscle -out mcrA_align.fasta
~/Private/Biocomputing2022/tools/hmmbuild mcrA_HMM mcrA_align.fasta

cat $1/hsp70gene_*.fasta | ~/Private/Biocomputing2022/tools/muscle -out hsp70_align.fasta
~/Private/Biocomputing2022/tools/hmmbuild hsp70_HMM hsp70_align.fasta

for proteome in $2/proteome_*.fasta
do
number=$(ls $proteome | grep -o "[0-9][0-9]")
echo $number
~/Private/Biocomputing2022/tools/hmmsearch --tblout mcrA_seqmatch$number mcrA_HMM $proteome
~/Private/Biocomputing2022/tools/hmmsearch --tblout hsp70_seqmatch$number hsp70_HMM $proteome
done

cat mcrA_seqmatch* > all_mcrA_matches
cat hsp70_seqmatch* > all_hsp70_matches

clear

for mcrA_entry in mcrA_seqmatch*
do
grep -w -E "\s\-\s|Target file\: " $mcrA_entry | grep -o "proteome_[0-9][0-9]" >> proteome.txt
grep -w -E "\s\-\s" $mcrA_entry | wc -l >> mcrA.txt 
done

for hsp70_entry in hsp70_seqmatch*
do
grep -w -E "\s\-\s" $hsp70_entry | wc -l >> hsp70.txt 
done

paste proteome.txt mcrA.txt hsp70.txt -d "," 
