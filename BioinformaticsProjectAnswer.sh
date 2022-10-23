#Final Table Name: finaltable.txt 
#Final Proteome Candidates: proteomecandidates.txt
#Assumption that our file system looks the same as the Graduate Student
#Usage: bash BioinformaticsProjectAnswer.sh
#Creating the Muscle for hspGenes
cd ~/Private/bioinformaticsProject/ref_sequences | cat hsp70gene_*.fasta >> hspgenes.txt | ~/Private/Biocomputing2022/tools/muscle -in hspgenes.txt -out hspGenesmuscle.txt
#HmmBuild for hspGenes
~/Private/Biocomputing2022/tools/hmmbuild hmmbuild.hsp hspGenesmuscle.txt
#Copy hmmbuild.hsp  to Proteome Directory
cp hmmbuild.hsp ../proteomes
#Move to Proteomes Directory to Run for loop
~/Private/bioinformaticsProject/proteomes


#Creating the Muscle for the mcrAgenes
cd ~/Private/bioinformaticsProject/ref_sequences | cat mcrAgene_*.fasta >> mcrAgene.txt | ~/Private/Biocomputing2022/tools/muscle -in mcrAgene.txt -out mcrAmuscle.txt
#HmmBuild for mcrAgenes
~/Private/Biocomputing2022/tools/hmmbuild hmmbuild.mcrA mcrAmuscle.txt
#Copy hmmbuild.mcrA to Proteomes Directory
cp hmmbuild.mcrA ../proteomes
#Move to Proteomes Directory to Run For Loop
~/Private/bioinformaticsProject/proteomes

#Make Final File
echo proteome name, mcrAgenes, hsp70genes >> final.txt

#HmmSearch for Loop for both Hsp70 and mcrA
for file in proteome_*.fasta
do 
#HmmSearch for hspgenes
	~/Private/Biocomputing2022/tools/hmmsearch --tblout hmm.hspSearch${file} hmmbuild.hsp $file
#HmmSearch for mcrAgenes
	~/Private/Biocomputing2022/tools/hmmsearch --tblout hmmSearch.mcrA${file} hmmbuild.mcrA $file
#Define Proteome Variable
	proteome=$(echo $file)
#Define mcrA Variable
	mcrAmatches=$(cat hmmSearch.mcrA${file} | grep -v "#" | wc -l)
#Define hsp70 Variable
	hsp70matches=$(cat hmm.hspSearch${file} | grep -v "#" | wc -l)
#Put Loop Results in a text file
	echo "$proteome,$mcrAmatches,$hsp70matches" >> final.txt
#Finish For Loop
done

#Remove .fasta from proteome names to Complete Final Table
cat final.txt | tr "." "," | cut -d , -f 1,3,4 >> finaltable.txt

#Make File With pH resistant methanogens
echo Top 15 candidate pH-resistant methanogens >> pH.txt
#See if mcrA is present, sort by hsp70 genes and  give top 15 results
cat finaltable.txt | grep -E ,[1-2], | sort -t, -k3 -r | head -n 15 >> pH.txt
#Give name of final 15 Proteomes
cat pH.txt | cut -d , -f 1 >> proteomecandidates.txt

