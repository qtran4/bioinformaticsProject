#start in the bioinformaticsProject
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




