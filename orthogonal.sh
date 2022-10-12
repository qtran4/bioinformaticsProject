# Identifying candidate pH-resistant methanogenic Archaea
# Usage: bash orthogonal.sh $1 $2 $3 $4
# $1 and $2 are the names of references gene, $3 is the name of genomes to be search, $4 is the result file.
# Exp:  bash orthogonal.sh mcrA hsp70 proteome final_result.txt

cat ref_sequences/$1* > tot_$1.fasta
cat ref_sequences/$2* > tot_$2.fasta


# Combine and align reference sequences
~/Private/BioComputing2022/tools/muscle -in tot_$1.fasta -out $1_aligned.fasta
~/Private/BioComputing2022/tools/muscle -in tot_$2.fasta -out $2_aligned.fasta

# Build HMM profiles
~/Private/BioComputing2022/tools/hmmbuild $1.hmm $1_aligned.fasta
~/Private/BioComputing2022/tools/hmmbuild $2.hmm $2_aligned.fasta

# Write headers for the final result file
echo -e "proteomes" "\t" "num of $1 match" "\t" "num of $2 match" > $4

for i in {01..50}
do
# Search ref sequences in proteomes, output in repo "before merged"
~/Private/BioComputing2022/tools/hmmsearch --tblout befMerged/$1_match_$i $1.hmm proteomes/$3_$i.fasta
~/Private/BioComputing2022/tools/hmmsearch --tblout befMerged/$2_match_$i $2.hmm proteomes/$3_$i.fasta

# Count the matches
numA=$(cat befMerged/$1_match_$i | grep -c WP)
numB=$(cat befMerged/$2_match_$i | grep -c WP)

# Output matches
echo -e $3_$i "\t" $numA "\t" $numB >> $4

done

