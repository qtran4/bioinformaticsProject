#usage: bash bash_project.sh

#This  script assumes a file structure similar to the structure we discussed in class. The pwd is a directory called bioinformaticsProject with a parent directory called Biocomputing2022.
#Within Biocomputing2022, there is another directory called tools which contains the muscle, hmmbuild, and hmmsearch.
#Within bioinformaticsProject (the pwd), there is the bash_project.sh script and two child directories.
#One directory is called ref_sequences which contains reference sequences for mcrA and hsp70, and the other directory is called proteomes which contains the data for 50 proteomes.
#The goal is to create a table with each proteome, the number of mcrA genes present, and the number of hsp70 genes present. The second goal is to create a file with recommended proteomes for the project.

#First, the mcrA genes are processed
#create one file with all mcrA reference genes
cat ./ref_sequences/mcrAgene*.fasta >> ./ref_sequences/mcrA_master.fasta

#Use muscle to align mcrA
../tools/muscle -in ./ref_sequences/mcrA_master.fasta -out mcrAgene_alignment.align

#Use hmm build to create an HMM for mcrA
../tools/hmmbuild hmmbuild_results_mcrA.hmm mcrAgene_alignment.align

#Use hmm search to search each proteome for matches to mcrA
#the output files for hmm search are created in the proteomes directory
for file in proteomes/*.fasta
do
../tools/hmmsearch --tblout $file-mcrA.out hmmbuild_results_mcrA.hmm $file
done

#second, the same process is repeated for hsp70 genes
#cat all HSP reference sequences into master file
cat ./ref_sequences/hsp70gene*.fasta >> ./ref_sequences/hsp70_master.fasta

#Use muscle to align hsp70
../tools/muscle -in ./ref_sequences/hsp70_master.fasta -out hsp70_alignment.align

#Use hmm build to create HMM for hsp 70
../tools/hmmbuild hmmbuild_results_hsp.hmm hsp70_alignment.align

#Use hmm search to search each proteome for matches to hsp70
#this creates result files in the proteomes directory
for file in proteomes/*.fasta
do
../tools/hmmsearch --tblout $file-hsp.out hmmbuild_results_hsp.hmm $file
done

#Third, a table with all results (proteome, number of mcrA genes present, and number of hsp70 genes present) is created. This accomplished goal #1
#This creates a file with the full table of results called full_table.txt
echo "proteome, number of mcrA genes, number of hsp70 genes" > full_table.txt
for file in proteomes/proteome_*.fasta
do
proteome=$(echo $file)
mcrA=$(cat $file*-mcrA.out | grep -v "#" | uniq | wc -l)
hsp70=$(cat $file*-hsp.out | grep -v "#" | uniq | wc -l)
echo "$proteome, $mcrA, $hsp70" | sed 's/proteomes\///g' >> full_table.txt
done

#Lastly, the contents of the full results table is sorted to return only proteomes with the mcrA gene present.
#Then, the output is sorted by the number of hsp70 genes present.
#The top 8 proteome candidates based on the presence of mcrA and a high number of hsp70 genes present are listed in a file created called recommended_proteomes.txt. This accomplished goal #2
cat full_table.txt | tail -n 50 | grep -v "0," | sort -t , -k 3,3n | tail -n 8 > recommended_proteomes.txt

#contents of recommended_proteomes.txt:
#proteome number, number of mcrA genes, number of hsp70 genes
#proteome_05.fasta, 1, 2
#proteome_07.fasta, 1, 2
#proteome_23.fasta, 2, 2
#proteome_24.fasta, 1, 2
#proteome_03.fasta, 1, 3
#proteome_42.fasta, 1, 3
#proteome_45.fasta, 1, 3
#proteome_50.fasta, 1, 3
