#therese reisch, tara neufell, and kevin buck bash project :))
#start in the bioinformaticsProject, all of this code is assuming that our TA has the same directory structure as we do
#usage: bash genemachine.sh

#put all of the mcrA reference files into one file and all of the hsp gene reference files into another file
touch  ref_sequences/mcrAmaster.fasta
for index in {01..18}
	do cat ref_sequences/mcrAgene_$index.fasta >> ref_sequences/mcrAmaster.fasta
done

touch ref_sequences/hsp70master.fasta
for index in {01..22}
	do cat ref_sequences/hsp70gene_$index.fasta >> ref_sequences/hsp70master.fasta
done

#aligning reference files using muscle tool
~/Private/biocomputing2022/tools/muscle -in ref_sequences/mcrAmaster.fasta -out ref_sequences/mcrAmaster.aligned
~/Private/biocomputing2022/tools/muscle -in ref_sequences/hsp70master.fasta -out ref_sequences/hsp70master.aligned

#build hidden markov model with hmmer tool
~/Private/biocomputing2022/tools/hmmbuild ref_sequences/mcrAmaster.build ref_sequences/mcrAmaster.aligned
~/Private/biocomputing2022/tools/hmmbuild ref_sequences/hsp70master.build ref_sequences/hsp70master.aligned

#search proteome sequences for mcrA with hmmr search tool
for index in {01..50}
	do ~/Private/biocomputing2022/tools/hmmsearch --tblout proteomes/proteome$index.mcrAsearch ref_sequences/mcrAmaster.build proteomes/proteome_$index.fasta
done
 
#search proteome sequences for hsp70 with hmmr search tool
for index in {01..50}
        do ~/Private/biocomputing2022/tools/hmmsearch --tblout proteomes/proteome$index.hsp70search ref_sequences/hsp70master.build proteomes/proteome_$index.fasta
done 

#making the summary table with headers
touch proteomecounttable.txt
echo proteome_name, mcrA_count, hsp70_count >> proteomecounttable.txt

#counting gene matches and appending them to summary table
for index in {01..50}
	do mcrAcount=$(grep -v -c "#" proteomes/proteome$index.mcrAsearch)
	hsp70count=$(grep -v -c "#" proteomes/proteome$index.hsp70search)
	echo "proteome_$index, $mcrAcount, $hsp70count" >> proteomecounttable.txt
done

#making the recommendation list after removing proteomes with no mcrA genes and then sorting from highest to lowest hsp70 genes
touch recommendationslist.txt
echo proteome_name, mcrA_count, hsp70_count >> recommendationslist.txt
cat proteomecounttable.txt | grep -E ", [1|2]," | sort -t , -k 3 -n -r >> recommendationslist.txt

