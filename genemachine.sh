#start in the bioinformaticsProject, all of this code is assuming that out TA has the same directory structure as we do
#this code can be used to put all of the mcrA reference files into one file and all of the hsp gene reference files into another file
touch  ref_sequences/mcrAmaster.fasta
for index in {01..18}
	do cat ref_sequences/mcrAgene_$index.fasta >> ref_sequences/mcrAmaster.fasta
done

touch ref_sequences/hsp70master.fasta
for index in {01..22}
	do cat ref_sequences/hsp70gene_$index.fasta >> ref_sequences/hsp70master.fasta
done

#aligning reference files
~/Private/biocomputing2022/tools/muscle -in ref_sequences/mcrAmaster.fasta -out ref_sequences/mcrAmaster.aligned
~/Private/biocomputing2022/tools/muscle -in ref_sequences/hsp70master.fasta -out ref_sequences/hsp70master.aligned

#build things with hmmer
~/Private/biocomputing2022/tools/hmmbuild ref_sequences/mcrAmaster.build ref_sequences/mcrAmaster.aligned
~/Private/biocomputing2022/tools/hmmbuild ref_sequences/hsp70master.build ref_sequences/hsp70master.aligned

#search mcrA with hmmr
for index in {01..50}
	do ~/Private/biocomputing2022/tools/hmmsearch --tblout proteomes/proteome$index.mcrAsearch ref_sequences/mcrAmaster.build proteomes/proteome_$index.fasta
done
 
#search hsp70 with hmmr
for index in {01..50}
        do ~/Private/biocomputing2022/tools/hmmsearch --tblout proteomes/proteome$index.hsp70search ref_sequences/hsp70master.build proteomes/proteome_$index.fasta
done 

#making the table textfile
touch proteomecounttable.txt
echo proteome_name, mcrA_count, hsp70_count >> proteomecounttable.txt

#coounting the matches
for index in {01..50}
	do mcrAcount=$(grep -v -c "#" proteomes/proteome$index.mcrAsearch)
	hsp70count=$(grep -v -c "#" proteomes/proteome$index.hsp70search)
	echo "proteome_$index, $mcrAcount, $hsp70count" >> proteomecounttable.txt
done
