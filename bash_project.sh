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

#grep to find if the proteome has the mcrA gene
for file in proteomes/*_mcrA.out
do
echo $file
grep -v "#" $file | uniq | wc -l
done

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

#grep to find how many hsp70 genes there are
for file in proteomes/*_hsp.out
do
echo $file
grep -v "#" $file | uniq | wc -l
done
