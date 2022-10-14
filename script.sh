mkdir outputfile
#all  mcrA in one particular file: output file
for file in ~/Private/bioinformaticsPoject/ref_sequences/m*.fasta
do 
cat $file >> ~/Private/bioinformaticsProject/outputfile/mcragene_total.txt
done 

#all hsp in one particular file: output file
for file in ~/Private/bioinformaticsProject/ref_sequences/h*.fasta
do 
cat $file >> ~/Private/bioinformaticsProject/outputfile/hsp_total.txt  
done 




#align multiple reference sequences for the mcra gene and hsp  
~/Private/Biocomputing2022/tools/muscle -in ~/Private/bioinformaticsProject/outputfile/mcragene_total.txt -out ~/Private/bioinformaticsProject/output/aligned_mcrA.txt
~/Private/Biocomputing2022/tools/muscle -in ~/Private/bioinformaticsProject/outputfile/hsp_total.txt -out ~/Private/bioinformaticsProject/output/aligned_hsp.txt 

#use hmmbuild 
~/Private/Biocomputing2022/tools/hmmbuild ~/Private/bioinformaticsProject/outputfile/mcrA.hmm ~/Private/bioinformaticsProject/outputfile/aligned_mcrA.txt
~/Private/Biocomputing2022/tools/hmmbuild ~/Private/bioinformaticsProject/outputfile/hsp.hmm ~/Private/bioinformaticsProject/outputfile/aligned_hsp.txt

##Search each proteom using hmm search###
cd ~/Private/bioinformaticsProject/proteomes
for file in *.fasta
do 
~/Private/Biocomputing2022/tools/hmmsesarch -E "1" --tblout ~/Private/bioinformaticsProject/outputfile/$file.mcrAout ~/Private/bioinformaticsProject/outputfile/mcrA.hmm $file
done

for file in *.fasta
do 
~/Private/Biocomputing2022/tools/hmmsesarch -E "1" --tblout ~/Private/bioinformaticsProject/outputfile/$file.hspout ~/Private/bioinformaticsProject/outputfile/hsp.hmm $file
done

##csv file###
echo "name,mcrA_match,hsp_match"> ~/Private/bioinformaticsProject/finalfile.csv
cd ~Private/bioinformaticsProject/proteomes
for file in *.fasta
do
name=$(echo $file)
mcrA_match=$(grep -v "#" ~/Private/bioinformaticsProject/outputfile/$file.mcrAout | wc -l)
hsp_match=$(grep -v "#" ~/Private/bioinformaticsProject/outputfile/$file.hspout | wc -l) 
echo "$name,$mcrA_match,$hsp_match">>~/Private/bioinformaticsProject/finalfile.csv
done

sed -i 's/.fasta//g' ~Private/bioinformaticsProject/finalfile.csv




