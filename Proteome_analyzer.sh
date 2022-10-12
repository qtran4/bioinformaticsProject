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

file=$(ls "$2" | wc -l)

for proteome in {1..$file}
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout mcrA_seqmatch mcrA_HMM ($2/proteome_ [0]*$proteome.fasta)
~/Private/Biocomputing2022/tools/hmmsearch --tblout hsp70_seqmatch hsp70_HMM $proteome
done
