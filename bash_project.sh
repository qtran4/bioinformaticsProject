# create file with all mcrA genes
#cat ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/mcrAgene*.fasta >> ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/mcrA_master.fasta

# muscle mcrA
#~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/mcrA_master.fasta -out mcrAgene_alignment.align

# hmm build mcrA
#~/Private/Biocomputing2022/tools/hmmbuild hmmbuild_results_mcrA.hmm mcrAgene_alignment.align

# hmm search mcrA, CREATES FILES IN PROTEOMES DIRECTORY
#usage: bash bash_project.sh
#for file in proteomes/proteome_*.fasta
#do
#~/Private/Biocomputing2022/tools/hmmsearch --tblout $file_mcrA.out hmmbuild_results_mcrA.hmm $file
#done

# cat all HSP reference sequences into master file
#cat ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/hsp70gene*.fasta >> ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/hsp70_master.fasta

# muscle hsp70
#~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/hsp70_master.fasta -out hsp70_alignment.align

# hmm build hsp 70
#~/Private/Biocomputing2022/tools/hmmbuild hmmbuild_results_hsp.hmm hsp70_alignment.align

# hmm search hsp70, CREATES FILES IN PROTEOMES DIRECTORY
#usage: bash bash_project.sh
#for file in proteomes/*
#do
#~/Private/Biocomputing2022/tools/hmmsearch --tblout $file_hsp.out hmmbuild_results_hsp.hmm $file
#done

#create a file with the full table of results:
#grep to find if the proteome has the mcrA gene and find number of hsp70 genes
echo "proteome, number of mcrA genes, number of hsp70 genes" > full_table.txt
for file in proteomes/proteome_*.fasta
do
proteome=$(echo $file)
mcrA=$(cat $file*_mcrA.out | grep -v "#" | uniq | wc -l)
hsp70=$(cat $file*_hsp.out | grep -v "#" | uniq | wc -l)
echo "$proteome, $mcrA, $hsp70" | sed 's/proteomes\///g' >> full_table.txt
done

#sort table to better interpret results
cat full_table.txt | tail -n 50 | sed 's/proteomes\///g' | grep -v "0," | sort -t , -k 3,3n | tail -n 8 > recommended_proteomes.txt
