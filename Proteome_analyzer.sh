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

# Remove output from hmmsearch that clutters up terminal
clear

# Counts number of mcrA and hsp70 gene matches in each proteome and puts those numbers in separate text files
for mcrA_entry in mcrA_seqmatch*
do
grep -w -E "\s\-\s|Target file\: " $mcrA_entry | grep -o "proteome_[0-9][0-9]" >> proteome.txt
grep -w -E "\s\-\s" $mcrA_entry | wc -l >> mcrA.txt 
done

# Replaces numbers 1-9 (for copies of mcrA gene) with Y (indicates presence), and 0 with N (indicates absence)
cat mcrA.txt | sed -E 's/[1-9]+/Y/g' | tr '0' 'N' > mcrA_char.txt

for hsp70_entry in hsp70_seqmatch*
do
grep -w -E "\s\-\s" $hsp70_entry | wc -l >> hsp70.txt 
done

echo -e "Proteome_ID,mcrA_Presence_(Y/N),#_hsp70_gene_copies" > column_headers.txt
paste proteome.txt mcrA_char.txt hsp70.txt -d "," > final_table.txt 
cat final_table.txt >> column_headers.txt

# Displays completed table that summarizes the results of the hmmsearch: giving the proteome name, whether is has a mcrA gene (or genes) (given by Y or N),
# and the number of hsp70 genes found in the proteome (given by a number) 
cat column_headers.txt
echo ' '

# Creates a text file with the names of the candidate pH-resistant methanogens, which includes only the proteomes
# that have at least 1 mcrA gene and at least 1 hsp70 gene. This subset is then sorted by the number of hsp70 gene copies present in the genome,
# with the candidate methanogens that have the highest number of hsp70 gene copies displayed at the top.
echo "This is a list of proteomes ranked according to their potential as pH-resistant methanogens. This list is displayed as proteomeID,# of hsp70 gene copies" > recommend_table.txt
tail -n +2 column_headers.txt | grep -w "Y" | grep -E -w "[1-9]+" | sort -t ',' -k 3nr | cut -d ',' -f 1,3 >> recommend_table.txt
cat recommend_table.txt
