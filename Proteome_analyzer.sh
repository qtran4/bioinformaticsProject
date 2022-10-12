# This script takes an input of a certain number of proteomes and searches each genome for
# gene sequences of interest, using a Hidden Markov Model created with reference
# sequences of the given gene. The script then creates a summary table collating the results
# of all searches, and finally generates a text file containing its recommendations for
# pH-resistant methanogen candidate proteomes
# Usage: bash Proteome_analyzer.sh mcrA_gene_refsequences_directory hsp70_gene_refsequences_directory proteome_sequences_directory

ls "$1" | grep "mcrAgene" | cat | ~/Private/Biocomputing2022/tools/muscle -out mcrA_align.fasta
~/Private/Biocomputing2022/tools/hmmbuild mcrA_HMM mcrA_align.fasta

ls "$1" | grep "hsp70gene" | cat | ~/Private/Biocomputing2022/tools/muscle -out hsp70_align.fasta
~/Private/Biocomputing2022/tools/hmmbuild hsp70_HMM hsp70_align.fasta

file=$(ls "$2")

for proteome in $file
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout mcrA_seqmatch mcrA_HMM $proteome
~/Private/Biocomputing2022/tools/hmmsearch --tblout hsp70_seqmatch hsp70_HMM $proteome
done
