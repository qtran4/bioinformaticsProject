#This script concatenates all of the possible gene combos then uses muslce to
# align them.

# usage bash bioinformatics_project_script.sh

cat ./ref_sequences/hsp* > all_hsp.fasta
cat ./ref_sequences/mcr* > all_mcr.fasta
~/Private/Biocomputing2022/tools/muscle -in all_hsp.fasta -out hsp_muscle_output
~/Private/Biocomputing2022/tools/muscle -in all_mcr.fasta -out mcr_muscle_output
~/Private/Biocomputing2022/tools/hmmbuild hsp_hmmbuild_results hsp_muscle_output
~/Private/Biocomputing2022/tools/hmmbuild mcr_hmmbuild_results mcr_muscle_output

echo "Proteome Recommendation List" >> recommendation_list

for file in ./proteomes/*.fasta
do
echo $file | cut -c 13- | cut -c -11 >> countfile_proteomes 
~/Private/Biocomputing2022/tools/hmmsearch --tblout temp_output_hsp hsp_hmmbuild_results $file
echo "number of hsp genes:" >> countfile_proteomes
hsp_count=$(grep -v -c '#' temp_output_hsp)
echo $hsp_count >> countfile_proteomes
#cat temp_output_hsp | hsp_count="$(grep -v -c '#')" | hsp_count  >> countfile_proteomes
~/Private/Biocomputing2022/tools/hmmsearch --tblout temp_output_mcr mcr_hmmbuild_results $file
echo "number of mcr genes:" >> countfile_proteomes
mcr_count=$(grep -v -c '#' temp_output_mcr) 
echo $mcr_count >> countfile_proteomes

if (( $hsp_count>=1 )) && (( $mcr_count>=1))
then 
     	echo $file | cut -c 13- | cut -c -11 >> recommendation_list
fi
#echo "{$file}_hmmbuild_results"
done

