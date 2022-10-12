#start in the bioinformaticsProject
#this code can be used to put all of the mcrA reference files into one file and all of the hsp gene reference files into another file
touch  ref_sequences/mcrAmaster.fasta
for index in {01..18}
	do cat ref_sequences/mcrAgene_$index.fasta >> ref_sequences/mcrAmaster.fasta
done
