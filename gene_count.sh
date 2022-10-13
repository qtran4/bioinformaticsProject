#!/bin/bash
# Usage: bash gene_count.sh "gene1" "gene2"
# This script counts all of the occurrences of gene 1 and gene 2 in proteome files. Gene names are case-sensitive.
# This script works under the assumption that the user's file paths are as such: 
# pwd is the current project file, containing folders with the proteome sequences and reference sequences for both genes.
# ./proteomes
# ./ref_sequences
# all tools needed (muscle, hmmsearch, and hmmbuild) are located in an accessible tools folder outside of the project file
# ../tools
# Created by: Gretchen Andreasen, Carol de Souza Moreira, Isabella Gimon

# To start, we need to concatenate all of the reference sequences into one file per type (one file for gene 1, one file for gene 2)
cat ref_sequences/$1* >> ref_sequences/$1_all
cat ref_sequences/$2* >> ref_sequences/$2_all

# Next let's align these reference genes 
../tools/muscle -in ref_sequences/$1_all -out ref_sequences/$1_aligned
../tools/muscle -in ref_sequences/$2_all -out ref_sequences/$2_aligned

# Now let's use hmmbuild and build a profile (to use hmmsearch with)
../tools/hmmbuild ref_sequences/$1_profile ref_sequences/$1_aligned
../tools/hmmbuild ref_sequences/$2_profile ref_sequences/$2_aligned

# Now let's use hmmsearch to search for gene 1 and gene 2 in the proteomes
# To do this easily, make a list of all the files you want searched
ls proteomes | sed 's/.fasta//g' > file_list
# We also need specific directories for gene 1 and gene 2 results
mkdir $1_results
mkdir $2_results

# Now let's count gene 1
for i in `cat file_list`
do
../tools/hmmsearch -E "5"  --tblout $1_results/$i ref_sequences/$1_profile proteomes/$i.fasta
done

# And gene 2
for i in `cat file_list`
do
../tools/hmmsearch -E "5" --tblout $2_results/$i ref_sequences/$2_profile proteomes/$i.fasta
done

# Now to present the data. First we need to count the search results
# Count the number of mcra genes in the proteome search results
for i in `cat file_list`
do
cat $1_results/$i | grep -E -o "$1_aligned" | wc -l
done > proteome_$1_results

# Count the number of hsp70 genes in the proteome search results
for i in `cat file_list`
do
cat $2_results/$i | grep -E -o "$2_aligned" | wc -l
done > proteome_$2_results

# Combine the list of files and corresponding search results, and write a header for the data
{ echo -e "proteome  $1_count  $2_count"; paste file_list proteome_$1_results proteome_$2_results | column -s $'\t' -t; } > proteome_final.txt
