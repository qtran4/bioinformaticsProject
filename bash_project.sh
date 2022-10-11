# create file with all mcrA genes
# cat 
#~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/mcrAgene*.fasta >> ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/mcrAgene_master.fasta

# muscle
#~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/mcrAgene_master.fasta -out mcrAgene_alignment.align

# hmm build
#~/Private/Biocomputing2022/tools/hmmbuild hmmbuild_results_mcrA.txt mcrAgene_alignment.align

# hmm search
#usage: bash bash_project.sh 
#for file in proteomes/*.fasta
#do 
#~/Private/Biocomputing2022/tools/hmmsearch --tblout hmmsearch_results_mcrA.txt hmmbuild_results_mcrA.txt $file
#done

#grep to find if the proteome has the mcrA gene
#echo 
#grep -E "Target file" 

# cat all HSP reference sequences into master file
#cat ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/hsp70gene*.fasta >> ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/hsp70_master.fasta

# muscle
#~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/hsp70_master.fasta -out hsp70_alignment.align

# hmm build
#~/Private/Biocomputing2022/tools/hmmbuild hmmbuild_results_hsp.txt hsp70_alignment.align

# hmm search
# usage: bash bash_project.sh 
#for file in proteomes/*.fasta
#do 
# ~/Private/Biocomputing2022/tools/hmmsearch --tblout hmmsearch_results_hsp.txt hmmbuild_results_hsp.txt $file >> hmmsearch_results_hsp.txt
#done


