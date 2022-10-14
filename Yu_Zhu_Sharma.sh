#usage: this script could be run in the bioinformaticsproject folder, bash Yu_Zhu_Sharma.sh 

#make a directory for output file, and if script needs to be run again, run rm -r output before running this script
mkdir output

#put all mcrA in one file
for file in ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/m*.fasta
do 
cat $file >> ~/Private/Biocomputing2022/bioinformaticsProject/output/mcrAall.txt
done


#put all hsp in one file
for file in ~/Private/Biocomputing2022/bioinformaticsProject/ref_sequences/h*.fasta
do 
cat $file >> ~/Private/Biocomputing2022/bioinformaticsProject/output/hspall.txt
done

#align the mcrA and hsp genes using the muscle tool
~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/bioinformaticsProject/output/mcrAall.txt -out ~/Private/Biocomputing2022/bioinformaticsProject/output/alignedmcrA.txt
~/Private/Biocomputing2022/tools/muscle -in ~/Private/Biocomputing2022/bioinformaticsProject/output/hspall.txt -out ~/Private/Biocomputing2022/bioinformaticsProject/output/alignedhsp.txt

#use hmmbuild tool to build hmm profiles from a sequence alignment for both genes
~/Private/Biocomputing2022/tools/hmmbuild ~/Private/Biocomputing2022/bioinformaticsProject/output/mcrA.hmm ~/Private/Biocomputing2022/bioinformaticsProject/output/alignedmcrA.txt
~/Private/Biocomputing2022/tools/hmmbuild ~/Private/Biocomputing2022/bioinformaticsProject/output/hsp.hmm ~/Private/Biocomputing2022/bioinformaticsProject/output/alignedhsp.txt

#hmm search each proteom for mcrA genes and hsp genes, use 0.1 as a threshhold for E value
cd ~/Private/Biocomputing2022/bioinformaticsProject/proteomes
for file in *.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch -E "0.1" --tblout ~/Private/Biocomputing2022/bioinformaticsProject/output/$file.mcrAout ~/Private/Biocomputing2022/bioinformaticsProject/output/mcrA.hmm $file
done

for file in *.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch -E "0.1" --tblout ~/Private/Biocomputing2022/bioinformaticsProject/output/$file.hspout ~/Private/Biocomputing2022/bioinformaticsProject/output/hsp.hmm $file
done

#Write output csv with counts of matches for mcrA genes and hsp70 genes
echo "name,mcrA_match,hsp_match" > ~/Private/Biocomputing2022/bioinformaticsProject/Yu_Zhu_Sharma_final.csv
cd ~/Private/Biocomputing2022/bioinformaticsProject/proteomes
for file in *.fasta
do 
name=$(echo $file)
mcrA_match=$(grep -v "#" ~/Private/Biocomputing2022/bioinformaticsProject/output/$file.mcrAout | wc -l)
hsp_match=$(grep -v "#" ~/Private/Biocomputing2022/bioinformaticsProject/output/$file.hspout | wc -l)
echo "$name,$mcrA_match,$hsp_match" >> ~/Private/Biocomputing2022/bioinformaticsProject/Yu_Zhu_Sharma_final.csv
done

sed -i 's/.fasta//g' ~/Private/Biocomputing2022/bioinformaticsProject/Yu_Zhu_Sharma_final.csv 

#sort output csv to find out the most ideal proteomes
cat ~/Private/Biocomputing2022/bioinformaticsProject/Yu_Zhu_Sharma_final.csv | sed 1d | sort -t, -k1,2nr -k2,3nr
