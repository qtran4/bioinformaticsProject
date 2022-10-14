#This script concatenates all of the possible gene combos then uses muscle to
# align them.
# This script outputs 2 files, one .csv called countfile_proteomes.csv 
# which lists each proteome followed by the number of mcr genes and then hsp genes
# present in the proteome. The next file called recommendation_list.txt is a list of
# the proteomes that are recommended to keep studying because they contain both mcr and hsp
# genes. 

# usage bash bioinformatics_project_script.sh

cat ./ref_sequences/hsp* > all_hsp.fasta #all hsp to one file
cat ./ref_sequences/mcr* > all_mcr.fasta #all mcr to one file
~/Private/Biocomputing2022/Tools/muscle -in all_hsp.fasta -out hsp_muscle_output #build muscle for hsp
~/Private/Biocomputing2022/Tools/muscle -in all_mcr.fasta -out mcr_muscle_output #build muscle for mcr
~/Private/Biocomputing2022/Tools/hmmbuild hsp_hmmbuild_results hsp_muscle_output #use hmmbuild for hsp
~/Private/Biocomputing2022/Tools/hmmbuild mcr_hmmbuild_results mcr_muscle_output #use hmmbuild for mcr

echo "Proteome Number,Number of MCR Genes,Number of HSP Genes" > countfile_proteomes.csv; \ #create countfile
echo "Proteome Number" > recommendation_list.txt #create recommendation txt file

for file in ./proteomes/*.fasta #loop through all proteomes
do
name=$(echo $file | cut -c 13- | cut -c -11)  #save proteome name
~/Private/Biocomputing2022/Tools/hmmsearch --tblout temp_output_hsp hsp_hmmbuild_results $file #using hmmsearch to search for hsp in each proteome
hsp_count=$(grep -v -c '#' temp_output_hsp) # count the number of matches in the hmmsearch results for hsp
~/Private/Biocomputing2022/Tools/hmmsearch --tblout temp_output_mcr mcr_hmmbuild_results $file #using hmmsearch to search for mcr in each proteome
mcr_count=$(grep -v -c '#' temp_output_mcr) # count the number of matches in the hmmsearch results for mcr
echo "$name,$mcr_count,$hsp_count" >> countfile_proteomes.csv  # push name, mcr count, and hsp count to count file

done

cat countfile_proteomes.csv |sed 1d | sort -t"," -k2rn,2 -k3rn,3 | grep -v ',0' | cut -d ',' -f1 >> recommendation_list.txt # generate recommendation list based on proteomes with both hsp and mcr

rm temp_output_hsp # remove hsp temp file from directory
rm temp_output_mcr # remove mcr temp file from directory
