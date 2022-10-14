#This script concatenates all of the possible gene combos then uses muscle to
# align them.

# usage bash bioinformatics_project_script.sh

cat ./ref_sequences/hsp* > all_hsp.fasta
cat ./ref_sequences/mcr* > all_mcr.fasta
~/Private/Biocomputing2022/tools/muscle -in all_hsp.fasta -out hsp_muscle_output
~/Private/Biocomputing2022/tools/muscle -in all_mcr.fasta -out mcr_muscle_output
~/Private/Biocomputing2022/tools/hmmbuild hsp_hmmbuild_results hsp_muscle_output
~/Private/Biocomputing2022/tools/hmmbuild mcr_hmmbuild_results mcr_muscle_output

echo "Proteome Number,Number of MCR Genes,Number of HSP Genes" > countfile_proteomes.csv; \
echo "Proteome Number" > recommendation_list.txt

for file in ./proteomes/*.fasta
do
name=$(echo $file | cut -c 13- | cut -c -11) 
~/Private/Biocomputing2022/tools/hmmsearch --tblout temp_output_hsp hsp_hmmbuild_results $file
hsp_count=$(grep -v -c '#' temp_output_hsp)
~/Private/Biocomputing2022/tools/hmmsearch --tblout temp_output_mcr mcr_hmmbuild_results $file
mcr_count=$(grep -v -c '#' temp_output_mcr) 
echo "$name,$mcr_count,$hsp_count" >> countfile_proteomes.csv 

done

cat countfile_proteomes.csv |sed 1d | sort -t"," -k2rn,2 -k3rn,3 | grep -v ',0' | cut -d ',' -f1 >> recommendation_list.txt

rm temp_output_hsp
rm temp_output_mcr
